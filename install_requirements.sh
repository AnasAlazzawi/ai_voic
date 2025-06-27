#!/bin/bash
# ملف إعداد محسن لحل مشاكل التثبيت

echo "🔧 بدء إعداد البيئة المحسنة..."

# تحديث pip
echo "📦 تحديث pip..."
python -m pip install --upgrade pip

# تثبيت المتطلبات الأساسية أولاً
echo "🏗️ تثبيت المتطلبات الأساسية..."
pip install livekit-agents
pip install livekit-plugins-google
pip install livekit-plugins-silero

# تثبيت المرافق
echo "🛠️ تثبيت المرافق..."
pip install requests
pip install python-dotenv
pip install duckduckgo-search

# محاولة تثبيت noise cancellation (اختياري)
echo "🔇 محاولة تثبيت noise cancellation..."
pip install livekit-plugins-noise-cancellation || echo "⚠️ noise cancellation غير متوفر، سيتم التشغيل بدونه"

echo "✅ تم إعداد البيئة بنجاح!"
