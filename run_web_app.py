#!/usr/bin/env python3
"""
TaskFlow Web App Launcher
Starts a local web server to serve the TaskFlow application.
"""

import http.server
import socketserver
import webbrowser
import os
import sys

PORT = 8000
DIRECTORY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "build", "web")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

def main():
    if not os.path.exists(DIRECTORY):
        print(f"Error: Web build directory not found at {DIRECTORY}")
        print("Please run 'flutter build web --release' first.")
        print("Or place your web build files in the 'build/web' directory.")
        input("Press Enter to exit...")
        return

    os.chdir(DIRECTORY)

    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"TaskFlow Web App Server")
        print(f"========================")
        print(f"Serving at http://localhost:{PORT}")
        print(f"Directory: {DIRECTORY}")
        print(f"")
        print(f"Open your browser and navigate to:")
        print(f"http://localhost:{PORT}")
        print(f"")
        print(f"Press Ctrl+C to stop the server")

        # Try to open browser automatically
        try:
            webbrowser.open(f"http://localhost:{PORT}")
        except:
            pass

        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")

if __name__ == "__main__":
    main()
