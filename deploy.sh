#!/bin/bash

# Friday JARVIS - Railway Deployment Script

echo "🚀 تجهيز المشروع للنشر على Railway..."

# التحقق من وجود الملفات المطلوبة
if [ ! -f ".env" ]; then
    echo "⚠️  ملف .env غير موجود. نسخ من .env.example..."
    cp .env.example .env
    echo "📝 يرجى تحديث ملف .env بمعلوماتك الصحيحة"
fi

# تثبيت المتطلبات
echo "📦 تثبيت المتطلبات..."
pip install -r requirements.txt

# توليد التوكن
echo "🔑 توليد التوكن..."
python generate_token.py

# بناء صورة Docker للاختبار
echo "🐳 بناء صورة Docker..."
docker build -t friday-jarvis .

echo "✅ المشروع جاهز للنشر على Railway!"
echo ""
echo "📝 خطوات النشر:"
echo "1. ارفع الكود إلى GitHub"
echo "2. اربط المستودع بـ Railway"
echo "3. أضف متغيرات البيئة في Railway:"
echo "   - LIVEKIT_API_KEY"
echo "   - LIVEKIT_API_SECRET"
echo "   - GOOGLE_API_KEY"
echo "   - OPENWEATHERMAP_API_KEY"
echo "4. انتظر اكتمال النشر"
echo ""
echo "🎯 رابط LiveKit: wss://aivoic-tqnojuug.livekit.cloud"
