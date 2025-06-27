# استخدام Python 3.11 كصورة أساسية أكثر أماناً
FROM python:3.11-slim-bullseye

# تعيين متغيرات البيئة
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONPATH=/app
ENV MEMORY_LIMIT=512m

# تثبيت متطلبات النظام
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مجلد العمل
WORKDIR /app

# نسخ ملف المتطلبات وتثبيت المكتبات
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# نسخ الكود المصدري
COPY . .

# إنشاء مجلد للوقس
RUN mkdir -p KMS/logs

# تعيين منفذ التطبيق
EXPOSE $PORT

# تشغيل الوكيل مع معالجة أفضل للأخطاء
CMD ["python", "-u", "agent.py", "start"]
