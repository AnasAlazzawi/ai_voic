#!/bin/bash
# Railway Startup Script

echo "🚀 بدء تشغيل Friday Jarvis Assistant..."

# توليد Token جديد
echo "🔑 توليد Token جديد..."
python generate_token.py

if [ $? -eq 0 ]; then
    echo "✅ Token تم توليده بنجاح!"
    echo "🤖 بدء تشغيل الوكيل..."
    python agent.py start
else
    echo "❌ فشل في توليد Token!"
    exit 1
fi
