# استخدام صورة Python الرسمية
FROM python:3.10-slim

# تعيين مجلد العمل
WORKDIR /app

# نسخ ملفات المتطلبات أولاً لتحسين التخزين المؤقت
COPY requirements.txt .

# تثبيت المتطلبات
RUN pip install --no-cache-dir -r requirements.txt

# نسخ باقي ملفات المشروع
COPY . .

# تعريف المنفذ
EXPOSE 8080

# تشغيل الوكيل
CMD ["python", "agent.py", "start"]
