#!/usr/bin/env python3
"""
FADE Dashboard Server

Lightweight HTTP server for monitoring FADE sessions across multiple repositories.
Uses only Python stdlib - no external dependencies required.
"""

import http.server
import json
import os
import signal
import socketserver
import sys
import threading
import time
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional


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

    def log_message(self, format, *args):
        """Log HTTP requests to console."""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{timestamp}] {self.address_string()} - {format % args}")

    def do_GET(self):
        """Handle GET requests."""
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

    def __init__(self, port: int, dashboard_data: DashboardData):
        self.port = port
        self.dashboard_data = dashboard_data
        self.httpd = None

        # Set up signal handlers for graceful shutdown
        signal.signal(signal.SIGINT, self._signal_handler)
        signal.signal(signal.SIGTERM, self._signal_handler)

    def _signal_handler(self, signum, frame):
        """Handle shutdown signals gracefully."""
        print("\n\nShutting down dashboard server...")
        if self.httpd:
            self.httpd.shutdown()
        sys.exit(0)

    def start(self):
        """Start the dashboard server."""
        # Initial data load
        self.dashboard_data.refresh_data()

        # Set up HTTP server
        DashboardRequestHandler.dashboard_data = self.dashboard_data

        try:
            with socketserver.TCPServer(("", self.port), DashboardRequestHandler) as httpd:
                self.httpd = httpd
                print(f"FADE Dashboard running at http://localhost:{self.port}")
                print("Press Ctrl+C to stop")
                print("")
                httpd.serve_forever()
        except OSError as e:
            if e.errno == 48:  # Address already in use
                print(f"ERROR: Port {self.port} is already in use", file=sys.stderr)
                print(f"Try a different port or stop the other process", file=sys.stderr)
                sys.exit(1)
            else:
                raise


def main():
    """Entry point for dashboard server."""
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

    # Start server
    server = DashboardServer(port, dashboard_data)
    server.start()


if __name__ == "__main__":
    main()
