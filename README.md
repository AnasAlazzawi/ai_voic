# Frid## ✨ الميزات / Features

- 🗣️ **محادثة صوتية ثنائية اللغة** / **Bilingual Voice Chat** (عربي/إنجليزي)
- 🌤️ **معلومات الطقس** / **Weather Information** لأي مدينة في العالم
- 🔍 **البحث في الويب** / **Web Search** باستخدام DuckDuckGo
- 🎭 **شخصية مميزة** / **Unique Personality** مثل Friday من Iron Man
- 📱 **دعم Flutter** / **Flutter Support** للتطبيقات المحمولة
- 🚀 **جاهز للنشر** / **Ready for Deployment** على Railway

### 🔄 ميزات متقدمة / Advanced Features:
- **إعادة الاتصال التلقائي** / **Auto-Reconnection**: السيرفر يبقى نشطاً بعد انقطاع المشاركين
- **زر إعادة الاتصال** / **Reconnect Button**: في تطبيق Flutter لسهولة الاستخدام
- **فحص صحة السيرفر** / **Health Monitoring**: endpoint `/health` للمراقبة
- **استقرار محسن** / **Enhanced Stability**: معالجة أفضل للأخطاء والجلساتs AI Assistant 🤖

مساعد ذكي متقدم مبني بـ LiveKit وGoogle AI، يدعم اللغة العربية والإنجليزية.

*An advanced AI assistant built with LiveKit and Google AI, supporting both Arabic and English.*

## ✨ الميزات / Features

- �️ **محادثة صوتية ثنائية اللغة** / **Bilingual Voice Chat** (عربي/إنجليزي)
- 🌤️ **معلومات الطقس** / **Weather Information** لأي مدينة في العالم
- � **البحث في الويب** / **Web Search** باستخدام DuckDuckGo
- 🎭 **شخصية مميزة** / **Unique Personality** مثل Friday من Iron Man
- � **دعم Flutter** / **Flutter Support** للتطبيقات المحمولة
- 🚀 **جاهز للنشر** / **Ready for Deployment** على Railway

## 🎯 Live Demo

الوكيل جاهز للاستخدام مع Flutter App باستخدام:
- **URL**: `wss://aivoic-tqnojuug.livekit.cloud`
- **Token**: صالح حتى 27 يونيو 2026

## 🚀 التثبيت والتشغيل / Installation & Setup

### التشغيل المحلي / Local Development:

```bash
# استنساخ المشروع / Clone the project
git clone https://github.com/AnasAlazzawi/ai_voic.git
cd ai_voic

# إعداد البيئة الافتراضية / Setup virtual environment
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/Mac
source .venv/bin/activate

# تثبيت المتطلبات / Install requirements
pip install -r requirements.txt

# إعداد متغيرات البيئة / Setup environment variables
# عدل ملف .env بمعلوماتك / Edit .env file with your credentials

# تشغيل الوكيل / Run the agent
python agent.py dev
```

## 🌐 النشر على Railway / Deploy to Railway

### 1. ربط المشروع / Connect Project:
- اذهب إلى [Railway.app](https://railway.app)
- New Project → Deploy from GitHub
- اختر مستودع `ai_voic`

### 2. إعداد متغيرات البيئة / Environment Variables:
```env
LIVEKIT_URL=wss://aivoic-tqnojuug.livekit.cloud
LIVEKIT_API_KEY=APIPPqaBtdj9SDA
LIVEKIT_API_SECRET=LU13efWOZDkL213Br42lft835DDuAyNYkeOcfAAT80wG
GOOGLE_API_KEY=AIzaSyAhuaaR0pjGTTB1QL2hIkQ8gyKO9HDvn8E
PORT=8081
```

## 📱 تطبيق Flutter / Flutter Integration

استخدم الكود في `flutter_integration_example.dart`:

```dart
// Token صالح حتى 2026-06-27 / Valid until 2026-06-27
final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUElQUHFhQnRkajlTREEiLCJleHAiOjE3ODI1NTExMDAsIm5iZiI6MTc1MTAxNTA5MCwic3ViIjoicmFpbHdheS11c2VyIiwidmlkZW8iOnsicm9vbSI6ImZyaWRheS1qYXJ2aXMtcm9vbSIsInJvb21Kb2luIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWV9fQ.tepSD4PFZZv8faTXMkEZ62jIH-4IKNqaw6ANJ6GgVbI';
```

## 🗣️ أمثلة للاستخدام / Usage Examples

### العربية / Arabic:
- "مرحبا فرايدي، كيف الطقس في الرياض؟"
- "ابحث لي عن أخبار التكنولوجيا"

### English:
- "Hello Friday, what's the weather in New York?"
- "Search for latest AI news"

### مختلط / Mixed:
- "Hi Friday, ما هو الطقس في دبي؟"

## 📝 ملاحظات مهمة / Important Notes

- **Token صالح حتى / Valid until**: 27 يونيو 2026
- **الغرفة / Room**: `friday-jarvis-room`
- **دعم اللغات / Languages**: العربية والإنجليزية
- **الميزات المحذوفة / Removed Features**: الكاميرا والإيميل (حسب الطلب)

---

**تم تطويره بـ ❤️ للمجتمع العربي**

**Built with ❤️ for the Arabic Community** 

