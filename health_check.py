#!/usr/bin/env python3
"""
ملف فحص صحة السيرفر لـ Railway
"""

import os
import sys
import requests
import time

def health_check():
    """فحص صحة السيرفر"""
    try:
        port = os.getenv("PORT", "8081")
        url = f"http://localhost:{port}/"
        
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            print("✅ السيرفر يعمل بشكل طبيعي")
            return True
        else:
            print(f"⚠️ السيرفر يرد برمز: {response.status_code}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ خطأ في الاتصال: {e}")
        return False
    except Exception as e:
        print(f"❌ خطأ عام: {e}")
        return False

if __name__ == "__main__":
    # انتظار قصير للسماح للسيرفر بالبدء
    time.sleep(2)
    
    if health_check():
        sys.exit(0)  # نجح
    else:
        sys.exit(1)  # فشل
