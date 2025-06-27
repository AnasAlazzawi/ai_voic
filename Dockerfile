# استخدام صورة Python الرسمية مع إضافات ضرورية
FROM python:3.11-slim

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# تعيين مجلد العمل
WORKDIR /app

# تحديث pip إلى أحدث إصدار
RUN pip install --upgrade pip

# نسخ ملفات التثبيت
COPY requirements.txt install_requirements.sh ./

# جعل ملف التثبيت قابل للتنفيذ
RUN chmod +x install_requirements.sh

# تثبيت المتطلبات مع النهج المحسن
RUN bash install_requirements.sh || pip install --no-cache-dir -r requirements.txt

# نسخ باقي ملفات المشروع
COPY . .

# إعداد متغيرات البيئة
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONIOENCODING=utf-8

# تعريف المنفذ
EXPOSE 8081

# جعل الملفات قابلة للتنفيذ
RUN chmod +x startup.sh setup_env.sh

# إنشاء مجلد للسجلات
RUN mkdir -p /app/logs

# تشغيل الوكيل مع Token generation
CMD ["bash", "startup.sh"]
