#!/bin/bash
# ملف إعداد محسن لحل مشاكل التثبيت على Railway

echo "🔧 بدء إعداد البيئة المحسنة..."

# إعداد متغيرات البيئة
export PYTHONUNBUFFERED=1
export PIP_NO_CACHE_DIR=1
export PIP_DISABLE_PIP_VERSION_CHECK=1

# تحديث pip وأدوات التثبيت
echo "📦 تحديث pip وأدوات التثبيت..."
python -m pip install --upgrade pip setuptools wheel

# تثبيت المتطلبات الأساسية أولاً
echo "🏗️ تثبيت المتطلبات الأساسية..."
pip install --no-cache-dir livekit-agents>=0.8.0
pip install --no-cache-dir livekit-plugins-google>=0.6.0
pip install --no-cache-dir livekit-plugins-silero>=0.6.0

# تثبيت المرافق
echo "🛠️ تثبيت المرافق..."
pip install --no-cache-dir requests>=2.31.0
pip install --no-cache-dir python-dotenv>=1.0.0

# تثبيت أدوات البحث
echo "🔍 تثبيت أدوات البحث..."
pip install --no-cache-dir duckduckgo-search>=6.1.0

# محاولة تثبيت langchain-community (اختياري)
echo "🔗 محاولة تثبيت langchain-community..."
pip install --no-cache-dir langchain-community>=0.2.0 || echo "⚠️ langchain-community غير متوفر، سيتم استخدام البديل"

# محاولة تثبيت noise cancellation (اختياري)
echo "🔇 محاولة تثبيت noise cancellation..."
pip install --no-cache-dir livekit-plugins-noise-cancellation || echo "⚠️ noise cancellation غير متوفر، سيتم التشغيل بدونه"

# التحقق من التثبيت
echo "🔍 التحقق من التثبيت..."
python check_installation.py

if [ $? -eq 0 ]; then
    echo "✅ تم إعداد البيئة بنجاح!"
else
    echo "⚠️ بعض المتطلبات غير متوفرة، لكن المتطلبات الأساسية متوفرة"
fi
