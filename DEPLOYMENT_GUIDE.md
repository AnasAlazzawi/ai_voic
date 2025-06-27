# 🚀 دليل النشر على Railway - Friday JARVIS

## المتطلبات المسبقة

- حساب GitHub
- حساب Railway (railway.app)
- مفاتيح API المطلوبة:
  - LiveKit API Key & Secret
  - Google AI API Key
  - OpenWeatherMap API Key

## 📋 خطوات النشر

### 1. رفع الكود إلى GitHub

```bash
git init
git add .
git commit -m "Initial commit for Railway deployment"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

### 2. النشر على Railway

1. اذهب إلى [railway.app](https://railway.app)
2. سجل الدخول باستخدام GitHub
3. انقر على "New Project"
4. اختر "Deploy from GitHub repo"
5. اختر مستودع المشروع

### 3. إعداد متغيرات البيئة

في لوحة تحكم Railway، اذهب إلى قسم "Variables" وأضف:

```
LIVEKIT_URL=wss://aivoic-tqnojuug.livekit.cloud
LIVEKIT_API_KEY=<your_livekit_api_key>
LIVEKIT_API_SECRET=<your_livekit_secret>
GOOGLE_API_KEY=<your_google_api_key>
OPENWEATHERMAP_API_KEY=<your_weather_api_key>
```

### 4. انتظار النشر

- Railway سيكتشف تلقائياً ملف `Dockerfile`
- سيقوم ببناء ونشر التطبيق
- ستحصل على URL للتطبيق المنشور

## ✅ التحقق من النشر

بعد النشر الناجح:
1. ستظهر حالة "Running" في Railway
2. يمكنك رؤية اللوقس في قسم "Logs"
3. الوكيل سيكون جاهزاً لاستقبال الاتصالات من Flutter

## 🔧 استكشاف الأخطاء

### مشاكل شائعة:

1. **فشل البناء**: تحقق من ملف requirements.txt
2. **خطأ في متغيرات البيئة**: تأكد من إضافة جميع المتغيرات المطلوبة
3. **مشاكل الشبكة**: تحقق من إعدادات LiveKit

### فحص اللوقس:

```bash
# في Railway Dashboard
Logs -> View all logs
```

## 📱 الخطوة التالية: تكامل Flutter

بعد النشر الناجح، استخدم معلومات الاتصال في تطبيق Flutter:

```dart
final String liveKitUrl = 'wss://aivoic-tqnojuug.livekit.cloud';
final String roomName = 'friday-jarvis-room';
// استخدم التوكن المولد من generate_token.py
```

## 📞 الدعم

- إذا واجهت مشاكل، تحقق من:
  - لوقس Railway
  - إعدادات LiveKit
  - صحة مفاتيح API

---
**ملاحظة**: تأكد من عدم رفع ملف `.env` الذي يحتوي على مفاتيح API الحقيقية إلى GitHub!
