#!/usr/bin/env python3
"""
FADE Dashboard Server

Lightweight HTTP server for monitoring FADE sessions across multiple repositories.
Uses only Python stdlib - no external dependencies required.
"""

import argparse
import base64
import http.server
import json
import os
import signal
import socket
import socketserver
import ssl
import sys
import threading
import time
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional


class RateLimiter:
    """Simple rate limiter tracking requests per IP address."""

    def __init__(self, max_requests: int = 100, window_seconds: int = 60):
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self.requests = defaultdict(list)  # IP -> list of timestamps

    def is_allowed(self, ip_address: str) -> bool:
        """Check if request from IP is within rate limit."""
        now = time.time()

        # Clean old requests outside the window
        self.requests[ip_address] = [
            ts for ts in self.requests[ip_address]
            if now - ts < self.window_seconds
        ]

        # Check if under limit
        if len(self.requests[ip_address]) >= self.max_requests:
            return False

        # Add current request
        self.requests[ip_address].append(now)
        return True


class DashboardData:
    """Manages dashboard data by reading status.json files from configured repos."""

    def __init__(self, config_path: str):
        self.config_path = config_path
        self.config = self._load_config()
        self.last_refresh = None
        self.repo_statuses = {}

    def _load_config(self) -> Dict:
        """Load dashboard configuration from ~/.fade-dashboard/config.json"""
        try:
            with open(self.config_path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return {
                "repos": [],
                "port": 8080,
                "refreshInterval": 30
            }
        except json.JSONDecodeError as e:
            print(f"ERROR: Invalid config JSON: {e}", file=sys.stderr)
            sys.exit(1)

    def refresh_data(self):
        """Refresh status data for all configured repositories."""
        self.last_refresh = datetime.now().isoformat()
        self.repo_statuses = {}

        for repo in self.config.get("repos", []):
            repo_path = os.path.expanduser(repo["path"])
            repo_name = repo["name"]

            # Try contained structure first, then legacy
            status_paths = [
                os.path.join(repo_path, "fade", "status.json"),
                os.path.join(repo_path, "status.json")
            ]

            status_data = None
            for status_path in status_paths:
                if os.path.exists(status_path):
                    try:
                        with open(status_path, 'r') as f:
                            status_data = json.load(f)
                        break
                    except (json.JSONDecodeError, IOError):
                        continue

            if status_data:
                self.repo_statuses[repo_name] = status_data
            else:
                # No status file found - repo is idle
                self.repo_statuses[repo_name] = {
                    "repoName": repo_name,
                    "status": "idle",
                    "lastUpdate": None
                }

    def get_aggregate_stats(self) -> Dict:
        """Calculate aggregate statistics across all repositories."""
        total_pending = 0
        total_completed = 0
        active_count = 0
        blocked_count = 0

        for repo_data in self.repo_statuses.values():
            if repo_data.get("status") == "running":
                active_count += 1
            elif repo_data.get("status") == "blocked":
                blocked_count += 1

            # Sum up work queue
            for prd in repo_data.get("workQueue", []):
                total_pending += prd.get("pendingCount", 0)

            total_completed += repo_data.get("completedThisSession", 0)

        return {
            "totalPending": total_pending,
            "totalCompleted": total_completed,
            "activeRepos": active_count,
            "blockedRepos": blocked_count,
            "totalRepos": len(self.config.get("repos", [])),
            "lastRefresh": self.last_refresh
        }


class DashboardRequestHandler(http.server.SimpleHTTPRequestHandler):
    """HTTP request handler for dashboard server."""

    dashboard_data: DashboardData = None
    rate_limiter: RateLimiter = None
    auth_password: Optional[str] = None
    access_log_file: Optional[str] = None

    def log_message(self, format, *args):
        """Log HTTP requests to console and access log file."""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        client_ip = self.address_string()
        log_entry = f"[{timestamp}] {client_ip} - {format % args}"

        # Print to console
        print(log_entry)

        # Write to access log file if configured
        if self.access_log_file:
            try:
                with open(self.access_log_file, 'a') as f:
                    f.write(log_entry + '\n')
            except IOError:
                pass  # Fail silently if can't write to log

    def check_auth(self) -> bool:
        """Check basic authentication if password is configured."""
        if not self.auth_password:
            return True  # No auth required

        auth_header = self.headers.get('Authorization', '')
        if not auth_header.startswith('Basic '):
            return False

        try:
            # Decode base64 credentials
            encoded_credentials = auth_header[6:]
            decoded = base64.b64decode(encoded_credentials).decode('utf-8')
            # Format is "username:password", we only check password
            if ':' in decoded:
                _, password = decoded.split(':', 1)
                return password == self.auth_password
            return False
        except Exception:
            return False

    def send_auth_required(self):
        """Send 401 Unauthorized response."""
        self.send_response(401)
        self.send_header('WWW-Authenticate', 'Basic realm="FADE Dashboard"')
        self.send_header('Content-Type', 'text/html')
        self.end_headers()
        self.wfile.write(b'<html><body><h1>401 Unauthorized</h1><p>Authentication required</p></body></html>')

    def check_rate_limit(self) -> bool:
        """Check if client is within rate limit."""
        if not self.rate_limiter:
            return True  # No rate limiting configured

        client_ip = self.client_address[0]
        return self.rate_limiter.is_allowed(client_ip)

    def send_rate_limit_error(self):
        """Send 429 Too Many Requests response."""
        self.send_response(429)
        self.send_header('Content-Type', 'text/html')
        self.send_header('Retry-After', '60')
        self.end_headers()
        self.wfile.write(b'<html><body><h1>429 Too Many Requests</h1><p>Rate limit exceeded. Try again later.</p></body></html>')

    def do_GET(self):
        """Handle GET requests."""
        # Check rate limit first
        if not self.check_rate_limit():
            self.send_rate_limit_error()
            return

        # Check authentication
        if not self.check_auth():
            self.send_auth_required()
            return

        # Handle routes
        if self.path == "/api/status":
            self._serve_status_api()
        elif self.path == "/api/aggregate":
            self._serve_aggregate_api()
        elif self.path == "/" or self.path == "/index.html":
            self._serve_file("index.html", "text/html")
        elif self.path == "/styles.css":
            self._serve_file("styles.css", "text/css")
        elif self.path == "/app.js":
            self._serve_file("app.js", "application/javascript")
        else:
            self.send_error(404, "Not Found")

    def _serve_status_api(self):
        """Serve /api/status endpoint with all repo statuses."""
        self.dashboard_data.refresh_data()
        data = {
            "repos": self.dashboard_data.repo_statuses,
            "lastRefresh": self.dashboard_data.last_refresh
        }

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

    def _serve_aggregate_api(self):
        """Serve /api/aggregate endpoint with aggregate statistics."""
        stats = self.dashboard_data.get_aggregate_stats()

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(stats).encode('utf-8'))

    def _serve_file(self, filename: str, content_type: str):
        """Serve static files from templates/dashboard/."""
        # Find templates directory relative to this script
        script_dir = Path(__file__).parent.parent
        file_path = script_dir / "templates" / "dashboard" / filename

        if not file_path.exists():
            self.send_error(404, f"File not found: {filename}")
            return

        try:
            with open(file_path, 'r') as f:
                content = f.read()

            self.send_response(200)
            self.send_header("Content-Type", content_type)
            self.end_headers()
            self.wfile.write(content.encode('utf-8'))
        except IOError as e:
            self.send_error(500, f"Error reading file: {e}")


class DashboardServer:
    """Dashboard HTTP server with graceful shutdown."""

    def __init__(
        self,
        port: int,
        dashboard_data: DashboardData,
        bind_address: str = "127.0.0.1",
        password: Optional[str] = None,
        cert_file: Optional[str] = None,
        key_file: Optional[str] = None
    ):
        self.port = port
        self.dashboard_data = dashboard_data
        self.bind_address = bind_address
        self.password = password
        self.cert_file = cert_file
        self.key_file = key_file
        self.httpd = None

        # Set up signal handlers for graceful shutdown
        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)

    def _signal_handler(self, signum, frame):
        """Handle shutdown signals gracefully."""
        print("\n\nServer stopped")
        if self.httpd:
            self.httpd.shutdown()
        sys.exit(0)

    def _get_local_ip(self) -> str:
        """Get the local IP address of this machine."""
        try:
            # Create a dummy socket to find local IP
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            local_ip = s.getsockname()[0]
            s.close()
            return local_ip
        except Exception:
            return "127.0.0.1"

    def start(self):
        """Start the dashboard server."""
        # Initial data load
        self.dashboard_data.refresh_data()

        # Set up request handler with configuration
        DashboardRequestHandler.dashboard_data = self.dashboard_data
        DashboardRequestHandler.auth_password = self.password
        DashboardRequestHandler.rate_limiter = RateLimiter(max_requests=100, window_seconds=60)

        # Set up access log
        access_log_path = os.path.expanduser("~/.fade-dashboard/access.log")
        os.makedirs(os.path.dirname(access_log_path), exist_ok=True)
        DashboardRequestHandler.access_log_file = access_log_path

        # Security warning if remote without password
        if self.bind_address == "0.0.0.0" and not self.password:
            print("\033[93mWARNING: Dashboard accessible to network without password\033[0m")
            print("Consider using --password flag for secure remote access")
            print("")

        try:
            # Create server
            with socketserver.TCPServer((self.bind_address, self.port), DashboardRequestHandler) as httpd:
                self.httpd = httpd

                # Add HTTPS support if cert/key provided
                if self.cert_file and self.key_file:
                    if not os.path.exists(self.cert_file):
                        print(f"ERROR: Certificate file not found: {self.cert_file}", file=sys.stderr)
                        sys.exit(1)
                    if not os.path.exists(self.key_file):
                        print(f"ERROR: Key file not found: {self.key_file}", file=sys.stderr)
                        sys.exit(1)

                    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
                    context.load_cert_chain(self.cert_file, self.key_file)
                    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
                    protocol = "https"
                else:
                    protocol = "http"

                # Display server URL with actual IP
                if self.bind_address == "0.0.0.0":
                    local_ip = self._get_local_ip()
                    print(f"Dashboard running at {protocol}://{local_ip}:{self.port}")
                    print(f"Also accessible at {protocol}://localhost:{self.port}")
                else:
                    print(f"Dashboard running at {protocol}://localhost:{self.port}")

                print("Press Ctrl+C to stop")
                print("")
                httpd.serve_forever()
        except OSError as e:
            if e.errno == 48 or e.errno == 98:  # Address already in use (macOS/Linux)
                print(f"ERROR: Port {self.port} is already in use", file=sys.stderr)
                print(f"Try a different port or stop the other process", file=sys.stderr)
                sys.exit(1)
            else:
                raise


def main():
    """Entry point for dashboard server."""
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='FADE Dashboard Server')
    parser.add_argument('--remote', action='store_true',
                        help='Bind to 0.0.0.0 for remote access (default: localhost only)')
    parser.add_argument('--password', type=str,
                        help='Require basic authentication with this password')
    parser.add_argument('--cert', type=str,
                        help='Path to SSL certificate file for HTTPS')
    parser.add_argument('--key', type=str,
                        help='Path to SSL key file for HTTPS')
    args = parser.parse_args()

    # Load config
    config_path = os.path.expanduser("~/.fade-dashboard/config.json")

    if not os.path.exists(config_path):
        print("ERROR: Dashboard not configured", file=sys.stderr)
        print("Run 'fade dashboard --add /path/to/repo' to add repositories", file=sys.stderr)
        sys.exit(1)

    # Create dashboard data manager
    dashboard_data = DashboardData(config_path)

    # Get port from config
    port = dashboard_data.config.get("port", 8080)

    # Determine bind address
    bind_address = "0.0.0.0" if args.remote else "127.0.0.1"

    # Validate cert/key pair
    if (args.cert and not args.key) or (args.key and not args.cert):
        print("ERROR: Both --cert and --key must be provided together", file=sys.stderr)
        sys.exit(1)

    # Start server
    server = DashboardServer(
        port=port,
        dashboard_data=dashboard_data,
        bind_address=bind_address,
        password=args.password,
        cert_file=args.cert,
        key_file=args.key
    )
    server.start()


if __name__ == "__main__":
    main()
