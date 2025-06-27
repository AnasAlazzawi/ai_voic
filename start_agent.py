#!/usr/bin/env python3
"""
Script wrapper لتشغيل البوت مع معالجة أفضل للأخطاء
"""

import sys
import time
import logging
import signal
import os
from typing import NoReturn

# إعداد اللوقينق
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    stream=sys.stdout
)

logger = logging.getLogger(__name__)

def signal_handler(signum, frame):
    """معالج الإشارات للإغلاق النظيف"""
    logger.info(f"Received signal {signum}. Shutting down gracefully...")
    sys.exit(0)

def main():
    """الدالة الرئيسية"""
    # تسجيل معالج الإشارات
    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)
    
    logger.info("Starting Friday JARVIS Agent...")
    logger.info(f"Python version: {sys.version}")
    logger.info(f"Working directory: {os.getcwd()}")
    
    # التحقق من متغيرات البيئة المطلوبة
    required_env_vars = [
        'LIVEKIT_API_KEY',
        'LIVEKIT_API_SECRET',
        'GOOGLE_API_KEY'
    ]
    
    missing_vars = []
    for var in required_env_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        logger.error(f"Missing environment variables: {', '.join(missing_vars)}")
        sys.exit(1)
    
    try:
        # استيراد وتشغيل الوكيل
        from agent import main as agent_main
        logger.info("Agent imported successfully")
        agent_main()
    except ImportError as e:
        logger.error(f"Failed to import agent: {e}")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Agent failed with error: {e}")
        time.sleep(5)  # انتظار قبل الخروج
        sys.exit(1)

if __name__ == "__main__":
    main()
