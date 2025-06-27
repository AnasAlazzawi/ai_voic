#!/usr/bin/env python3
"""
HTTP Health Check Server لـ Railway
"""

import os
import threading
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
import logging

logger = logging.getLogger(__name__)

class HealthCheckHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        """معالج طلبات GET"""
        if self.path == '/' or self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            
            response = {
                "status": "healthy",
                "service": "Friday Jarvis AI Assistant",
                "timestamp": time.time()
            }
            
            import json
            self.wfile.write(json.dumps(response).encode())
            
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        """كتم رسائل السجل العادية"""
        pass

def start_health_server():
    """بدء سيرفر فحص الصحة"""
    port = int(os.getenv("PORT", 8081)) + 1  # استخدام منفذ مختلف عن LiveKit
    
    try:
        server = HTTPServer(('0.0.0.0', port), HealthCheckHandler)
        logger.info(f"🌐 Health check server يعمل على المنفذ {port}")
        server.serve_forever()
    except Exception as e:
        logger.error(f"❌ خطأ في health check server: {e}")

if __name__ == "__main__":
    # تشغيل سيرفر فحص الصحة في thread منفصل
    health_thread = threading.Thread(target=start_health_server, daemon=True)
    health_thread.start()
    
    # الانتظار
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logger.info("⏹️ إيقاف health check server")
