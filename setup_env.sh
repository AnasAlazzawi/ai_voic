#!/bin/bash
# إعداد البيئة المحسنة لـ Railway

echo "⚙️ إعداد البيئة المحسنة..."

# تحسينات Python
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1
export PYTHONIOENCODING=utf-8

# تحسينات الذاكرة
export MALLOC_ARENA_MAX=2
export PYTHONMALLOC=malloc

# إعدادات LiveKit
export LIVEKIT_LOG_LEVEL=info

# إعدادات الشبكة
export LIVEKIT_TIMEOUT=30

echo "✅ تم إعداد البيئة المحسنة بنجاح"
