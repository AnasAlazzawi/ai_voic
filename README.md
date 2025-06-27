# Friday JARVIS - AI Voice Agent 🤖

مشروع وكيل ذكي للصوت باستخدام LiveKit وGoogle AI.

## 🚀 النشر على Railway

### الخطوة 1: إعداد متغيرات البيئة

في لوحة تحكم Railway، أضف المتغيرات التالية:

```bash
LIVEKIT_URL=wss://aivoic-tqnojuug.livekit.cloud
LIVEKIT_API_KEY=your_livekit_api_key
LIVEKIT_API_SECRET=your_livekit_secret
GOOGLE_API_KEY=your_google_api_key
OPENWEATHERMAP_API_KEY=your_weather_api_key
```

### الخطوة 2: ربط المستودع

1. قم بإنشاء مستودع جديد على GitHub
2. ارفع الكود إلى المستودع
3. اربط المستودع بـ Railway

### الخطوة 3: النشر

Railway سيكتشف تلقائياً الـ Dockerfile وسيقوم بالنشر.

## 📁 هيكل المشروع

```
friday_jarvis/
├── agent.py          # الوكيل الرئيسي
├── tools.py          # أدوات الوكيل
├── prompts.py        # تعليمات الوكيل
├── generate_token.py # مولد التوكن
├── Dockerfile        # إعدادات Docker
├── railway.json      # إعدادات Railway
├── requirements.txt  # المكتبات المطلوبة
└── Procfile         # أوامر التشغيل
```

## 🔧 الأدوات المتاحة

- **البحث على الويب**: استخدام DuckDuckGo
- **حالة الطقس**: عبر OpenWeatherMap API
- **ذاكرة المحادثة**: باستخدام Mem0

## 📱 التكامل مع Flutter

بعد النشر، استخدم الـ token المولد في تطبيق Flutter للاتصال بالوكيل.

```dart
final String _url = 'wss://aivoic-tqnojuug.livekit.cloud';
final String _token = 'your_generated_token';
final String _room = 'friday-jarvis-room';
```

## 🛠️ التطوير المحلي

```bash
# تثبيت المتطلبات
pip install -r requirements.txt

# تشغيل الوكيل
python agent.py
```
