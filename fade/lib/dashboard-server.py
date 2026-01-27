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

    def get_repo_path_by_name(self, repo_name: str) -> Optional[str]:
        """Get repository path by name from config."""
        for repo in self.config.get("repos", []):
            if repo["name"] == repo_name:
                return os.path.expanduser(repo["path"])
        return None

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

    def get_learning_metrics(self, repo_name: str) -> Dict:
        """Extract learning metrics from model-selection-history.json."""
        repo_path = self.get_repo_path_by_name(repo_name)
        if not repo_path:
            return {}

        # Try both contained and legacy structure
        history_paths = [
            os.path.join(repo_path, "fade", "model-selection-history.json"),
            os.path.join(repo_path, "model-selection-history.json")
        ]

        history_data = None
        for history_path in history_paths:
            if os.path.exists(history_path):
                try:
                    with open(history_path, 'r') as f:
                        history_data = json.load(f)
                    break
                except (json.JSONDecodeError, IOError):
                    continue

        if not history_data:
            return {}

        # Extract accuracy stats
        learned_heuristics = history_data.get("learnedHeuristics", {})
        accuracy_stats = learned_heuristics.get("accuracyStats", {})

        # Extract PRD list for recent escalations
        prds = history_data.get("prds", [])

        # Calculate model accuracy and PRD counts
        model_stats = {
            "haiku": {
                "accuracy": accuracy_stats.get("haiku_accuracy", 0),
                "count": sum(1 for p in prds if p.get("actualOutcome", {}).get("model") == "haiku"),
                "escalated": 0,
                "wasted": 0
            },
            "sonnet": {
                "accuracy": accuracy_stats.get("sonnet_accuracy", 0),
                "count": sum(1 for p in prds if p.get("actualOutcome", {}).get("model") == "sonnet"),
                "escalated": 0,
                "wasted": 0
            },
            "opus": {
                "accuracy": accuracy_stats.get("opus_accuracy", 0),
                "count": sum(1 for p in prds if p.get("actualOutcome", {}).get("model") == "opus"),
                "escalated": 0,
                "wasted": 0
            }
        }

        # Count escalations and wasted runs
        for prd in prds:
            outcome = prd.get("actualOutcome", {})
            if outcome.get("escalated"):
                model = outcome.get("model", "unknown")
                if model in model_stats:
                    model_stats[model]["escalated"] += 1
            # Wasted = sessions where model failed and needed escalation
            if outcome.get("sessions", 1) > 1 and outcome.get("escalated"):
                model = outcome.get("model", "unknown")
                if model in model_stats:
                    model_stats[model]["wasted"] += 1

        # Get key patterns (top 3 from decision tree rules)
        patterns = []
        for model_type in ["useHaikuIf", "useSonnetIf", "useOpusIf"]:
            rules = learned_heuristics.get(model_type, [])
            if rules and len(rules) > 0:
                # Take the top rule by confidence
                best_rule = max(rules, key=lambda r: r.get("confidence", 0))
                if best_rule.get("confidence", 0) > 0:
                    patterns.append({
                        "model": model_type.replace("useIf", "").replace("use", ""),
                        "pattern": best_rule.get("condition", ""),
                        "confidence": best_rule.get("confidence", 0),
                        "prds": best_rule.get("based_on_prds", 0)
                    })

        # Get recent escalations (last 3)
        recent_escalations = []
        for prd in sorted(prds, key=lambda p: p.get("date", ""), reverse=True)[:3]:
            if prd.get("actualOutcome", {}).get("escalated"):
                recent_escalations.append({
                    "id": prd.get("id", ""),
                    "date": prd.get("date", ""),
                    "reason": prd.get("actualOutcome", {}).get("escalationReason", "Unknown")
                })

        # Calculate cost savings (all-Sonnet vs actual)
        total_prds = len(prds)
        if total_prds > 0:
            # Rough pricing: haiku=$0.25, sonnet=$3, opus=$15 per 1M tokens (input)
            # Assume ~50k tokens per PRD
            haiku_count = model_stats["haiku"]["count"]
            sonnet_count = model_stats["sonnet"]["count"]
            opus_count = model_stats["opus"]["count"]

            cost_actual = (haiku_count * 0.25 + sonnet_count * 3 + opus_count * 15) / 20  # Normalize to 50k tokens
            cost_all_sonnet = total_prds * 3 / 20
            savings = max(0, cost_all_sonnet - cost_actual)
        else:
            savings = 0

        return {
            "modelStats": model_stats,
            "patterns": patterns,
            "recentEscalations": recent_escalations,
            "totalPrds": total_prds,
            "costSavings": round(savings, 2),
            "lastUpdated": history_data.get("lastUpdated", "Unknown"),
            "confidence": "High" if total_prds >= 10 else ("Medium" if total_prds >= 5 else "Low")
        }

    def get_aggregate_stats(self) -> Dict:
        """Calculate aggregate statistics across all repositories."""
        total_pending = 0
        total_completed = 0
        active_count = 0
        blocked_count = 0
        sessions_today = 0
        sessions_this_week = 0
        sessions_this_month = 0
        total_stories = 0
        healing_events = 0
        model_usage = {"haiku": 0, "sonnet": 0, "opus": 0}

        for repo_data in self.repo_statuses.values():
            if repo_data.get("status") == "running":
                active_count += 1
            elif repo_data.get("status") == "blocked":
                blocked_count += 1

            # Sum up work queue
            for prd in repo_data.get("workQueue", []):
                total_pending += prd.get("pendingCount", 0)

            total_completed += repo_data.get("completedThisSession", 0)

            # Aggregate analytics data
            analytics = repo_data.get("analytics", {})
            if analytics:
                aggregate = analytics.get("aggregate", {})
                sessions_today += aggregate.get("today", 0)
                sessions_this_week += aggregate.get("thisWeek", 0)
                sessions_this_month += aggregate.get("thisMonth", 0)
                total_stories += aggregate.get("totalStories", 0)
                healing_events += aggregate.get("healingEvents", 0)

                # Aggregate model usage
                repo_model_usage = aggregate.get("modelUsage", {})
                for model, count in repo_model_usage.items():
                    if model in model_usage:
                        model_usage[model] += count

        # Calculate model usage percentages
        total_model_usage = sum(model_usage.values())
        model_usage_pct = {}
        if total_model_usage > 0:
            for model, count in model_usage.items():
                if count > 0:
                    model_usage_pct[model] = round((count / total_model_usage) * 100, 1)

        return {
            "totalPending": total_pending,
            "totalCompleted": total_completed,
            "activeRepos": active_count,
            "blockedRepos": blocked_count,
            "totalRepos": len(self.config.get("repos", [])),
            "sessionsToday": sessions_today,
            "sessionsThisWeek": sessions_this_week,
            "sessionsThisMonth": sessions_this_month,
            "totalStories": total_stories,
            "modelUsage": model_usage,
            "modelUsagePct": model_usage_pct,
            "healingEvents": healing_events,
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
        elif self.path.startswith("/api/learning/"):
            self._serve_learning_api()
        elif self.path.startswith("/api/docs/"):
            self._serve_docs_api()
        elif self.path.startswith("/api/doc/"):
            self._serve_doc_content_api()
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

    def _serve_learning_api(self):
        """Serve /api/learning/{repoName} endpoint with learning metrics."""
        # Extract repo name from path: /api/learning/{repoName}
        path_parts = self.path.split('/')
        if len(path_parts) < 4:
            self.send_error(400, "Invalid request - repo name required")
            return

        repo_name = path_parts[3]
        metrics = self.dashboard_data.get_learning_metrics(repo_name)

        if not metrics:
            metrics = {
                "error": "No learning data available",
                "totalPrds": 0
            }

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(metrics).encode('utf-8'))

    def _serve_docs_api(self):
        """Serve /api/docs/{repoName} endpoint with list of documentation files."""
        # Extract repo name from path: /api/docs/{repoName}
        path_parts = self.path.split('/')
        if len(path_parts) < 4:
            self.send_error(400, "Invalid request - repo name required")
            return

        repo_name = path_parts[3]
        repo_path = self.dashboard_data.get_repo_path_by_name(repo_name)

        if not repo_path:
            self.send_error(404, f"Repository not found: {repo_name}")
            return

        # Define documentation files to look for (in priority order)
        doc_files = [
            ("FADE.md", "Project context and standards"),
            ("fade/progress.md", "Session history (last 50 entries)"),
            ("progress.md", "Session history (last 50 entries)"),
            ("fade/learned.md", "Discoveries and learnings"),
            ("learned.md", "Discoveries and learnings"),
            ("fade/healing-log.md", "Auto-healing log"),
            ("healing-log.md", "Auto-healing log")
        ]

        docs_list = []
        seen_names = set()  # Track to avoid duplicates (contained vs legacy)

        for doc_file, description in doc_files:
            full_path = os.path.join(repo_path, doc_file)
            if os.path.exists(full_path):
                # Get base name to avoid duplicates
                base_name = os.path.basename(doc_file)
                if base_name in seen_names:
                    continue
                seen_names.add(base_name)

                try:
                    stat_info = os.stat(full_path)
                    file_size = stat_info.st_size
                    modified_time = datetime.fromtimestamp(stat_info.st_mtime).isoformat()

                    docs_list.append({
                        "name": base_name,
                        "path": doc_file,
                        "description": description,
                        "size": file_size,
                        "modified": modified_time
                    })
                except OSError:
                    continue

        response = {
            "repoName": repo_name,
            "docs": docs_list
        }

        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(response).encode('utf-8'))

    def _serve_doc_content_api(self):
        """Serve /api/doc/{repoName}/{docPath} endpoint with document content."""
        # Extract repo name and doc path from URL: /api/doc/{repoName}/{docPath}
        path_parts = self.path.split('/')
        if len(path_parts) < 5:
            self.send_error(400, "Invalid request - repo name and doc path required")
            return

        repo_name = path_parts[3]
        doc_path = '/'.join(path_parts[4:])  # Join remaining parts for nested paths

        repo_path = self.dashboard_data.get_repo_path_by_name(repo_name)

        if not repo_path:
            self.send_error(404, f"Repository not found: {repo_name}")
            return

        # Security: ensure doc_path doesn't escape repo directory
        full_doc_path = os.path.normpath(os.path.join(repo_path, doc_path))
        if not full_doc_path.startswith(os.path.normpath(repo_path)):
            self.send_error(403, "Access denied")
            return

        if not os.path.exists(full_doc_path):
            self.send_error(404, f"Document not found: {doc_path}")
            return

        try:
            with open(full_doc_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # For progress.md, limit to last 50 entries
            if doc_path.endswith('progress.md'):
                content = self._limit_progress_entries(content, max_entries=50)

            response = {
                "name": os.path.basename(doc_path),
                "path": doc_path,
                "content": content
            }

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(json.dumps(response).encode('utf-8'))
        except IOError as e:
            self.send_error(500, f"Error reading document: {e}")

    def _limit_progress_entries(self, content: str, max_entries: int = 50) -> str:
        """Limit progress.md to last N entries."""
        lines = content.split('\n')

        # Find all entry headers (lines starting with ##)
        entry_indices = []
        for i, line in enumerate(lines):
            if line.startswith('## ') and not line.startswith('## YYYY-MM-DD'):
                entry_indices.append(i)

        # If fewer entries than max, return all
        if len(entry_indices) <= max_entries:
            return content

        # Take last max_entries
        start_index = entry_indices[-(max_entries)]
        limited_lines = lines[:10] + ['', f'... (showing last {max_entries} entries)', ''] + lines[start_index:]

        return '\n'.join(limited_lines)

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
