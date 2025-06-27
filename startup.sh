#!/bin/bash
# Railway Startup Script - محسن للأداء والاستقرار

echo "🚀 بدء تشغيل Friday Jarvis Assistant..."

# إعداد البيئة المحسنة
source setup_env.sh

echo "💾 إعدادات الذاكرة: محسنة لـ Railway"
echo "🌐 المنفذ: ${PORT:-8081}"

# تنظيف الذاكرة قبل البدء
echo "🧹 تنظيف الذاكرة..."

# توليد Token جديد
echo "🔑 توليد Token جديد..."
timeout 60s python generate_token.py

if [ $? -eq 0 ]; then
    echo "✅ Token تم توليده بنجاح!"
    echo "🚀 جاهز لبدء تشغيل الوكيل..."
    
    # إنشاء ملف PID للمراقبة
    echo $$ > /tmp/friday_jarvis.pid
    
    echo "🤖 بدء تشغيل الوكيل..."
    
    # تشغيل الوكيل مع إعادة التشغيل التلقائي في حالة الفشل
    while true; do
        python agent.py start
        exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            echo "✅ الوكيل تم إيقافه بشكل طبيعي"
            break
        else
            echo "⚠️ الوكيل توقف برمز: $exit_code"
            echo "🔄 إعادة تشغيل الوكيل خلال 5 ثوان..."
            sleep 5
        fi
    done
else
    echo "❌ فشل في توليد Token!"
    exit 1
fi
