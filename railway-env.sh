# Railway Environment Configuration
# هذا الملف يحتوي على إعدادات خاصة بـ Railway

# Memory Management
export MALLOC_ARENA_MAX=2
export PYTHONHASHSEED=0

# LiveKit Settings
export LIVEKIT_LOG_LEVEL=info
export LIVEKIT_DEVELOPMENT=false

# Python Settings
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

# Agent Settings
export AGENT_MAX_RETRIES=3
export AGENT_TIMEOUT=30

echo "Railway environment configured successfully"
