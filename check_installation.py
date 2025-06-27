#!/usr/bin/env python3
"""
فحص صحة التثبيت والمتطلبات
"""

import sys
import importlib

def check_import(module_name, package_name=None):
    """فحص إمكانية استيراد وحدة معينة"""
    try:
        importlib.import_module(module_name)
        print(f"✅ {package_name or module_name} - متوفر")
        return True
    except ImportError as e:
        print(f"❌ {package_name or module_name} - غير متوفر: {e}")
        return False

def main():
    """فحص جميع المتطلبات"""
    print("🔍 فحص صحة التثبيت...")
    print("-" * 50)
    
    requirements = [
        ("livekit.agents", "LiveKit Agents"),
        ("livekit.plugins.google", "Google Plugin"),
        ("livekit.plugins.silero", "Silero Plugin"),
        ("requests", "Requests"),
        ("dotenv", "Python-dotenv"),
        ("duckduckgo_search", "DuckDuckGo Search"),
        ("langchain_community", "LangChain Community (اختياري)"),
    ]
    
    success_count = 0
    for module, name in requirements:
        if check_import(module, name):
            success_count += 1
    
    print("-" * 50)
    print(f"📊 النتيجة: {success_count}/{len(requirements)} متطلب متوفر")
    
    if success_count >= 5:  # الحد الأدنى المطلوب
        print("✅ التثبيت نجح! يمكن تشغيل الوكيل.")
        return True
    else:
        print("❌ التثبيت فشل! تحقق من المتطلبات.")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
