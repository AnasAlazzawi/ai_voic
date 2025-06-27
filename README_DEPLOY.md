# Friday Jarvis AI Assistant 🤖

مساعد ذكي متقدم مبني بـ LiveKit وGoogle AI، يدعم اللغة العربية والإنجليزية.

## ✨ الميزات

- 🗣️ **محادثة صوتية ثنائية اللغة** (عربي/إنجليزي)
- 🌤️ **معلومات الطقس** لأي مدينة في العالم
- 🔍 **البحث في الويب** باستخدام DuckDuckGo
- 🎭 **شخصية مميزة** مثل Friday من Iron Man
- 📱 **دعم Flutter** للتطبيقات المحمولة

## 🚀 النشر على Railway

### 1. رفع المشروع لـ GitHub:
```bash
git init
git add .
git commit -m "Initial commit - Friday Jarvis AI Assistant"
git branch -M main
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

### 2. ربط Railway بـ GitHub:
1. اذهب إلى [Railway.app](https://railway.app)
2. اضغط "New Project"
3. اختر "Deploy from GitHub repo"
4. اختر المستودع الخاص بك

### 3. إعداد متغيرات البيئة في Railway:
```
LIVEKIT_URL=wss://aivoic-tqnojuug.livekit.cloud
LIVEKIT_API_KEY=APIPPqaBtdj9SDA
LIVEKIT_API_SECRET=LU13efWOZDkL213Br42lft835DDuAyNYkeOcfAAT80wG
GOOGLE_API_KEY=AIzaSyAhuaaR0pjGTTB1QL2hIkQ8gyKO9HDvn8E
PORT=8080
```

## 📱 Flutter Integration

استخدم الكود التالي في تطبيق Flutter:

```dart
// Token صالح حتى 2026-06-27
final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUElQUHFhQnRkajlTREEiLCJleHAiOjE3ODI1NTExMDAsIm5iZiI6MTc1MTAxNTA5MCwic3ViIjoicmFpbHdheS11c2VyIiwidmlkZW8iOnsicm9vbSI6ImZyaWRheS1qYXJ2aXMtcm9vbSIsInJvb21Kb2luIjp0cnVlLCJjYW5QdWJsaXNoIjp0cnVlLCJjYW5TdWJzY3JpYmUiOnRydWV9fQ.tepSD4PFZZv8faTXMkEZ62jIH-4IKNqaw6ANJ6GgVbI';

final String _url = 'wss://aivoic-tqnojuug.livekit.cloud';
```

## 🗣️ أمثلة للمحادثة

### عربي:
- "مرحبا فرايدي، كيف الطقس في الرياض؟"
- "ابحث لي عن أخبار التكنولوجيا"

### English:
- "Hello Friday, what's the weather in New York?"
- "Search for latest AI news"

### مختلط:
- "Hi Friday, ما هو الطقس في دبي؟"

## 🛠️ التطوير المحلي

```bash
# إعداد البيئة الافتراضية
python -m venv .venv
.venv\Scripts\activate  # Windows
source .venv/bin/activate  # Linux/Mac

# تثبيت المتطلبات
pip install -r requirements.txt

# تشغيل الوكيل
python agent.py dev
```

## 📝 ملاحظات

- Token الحالي صالح حتى **27 يونيو 2026**
- الوكيل يدعم **اللغة العربية والإنجليزية**
- **لا يوجد دعم للكاميرا أو الإيميل** (تم إلغاؤهما حسب الطلب)

## 🔧 استكشاف الأخطاء

### إذا انتهت صلاحية Token:
```bash
python generate_token.py
```

### إذا فشل الاتصال:
تأكد من:
1. صحة متغيرات البيئة
2. اتصال الإنترنت
3. صلاحية Token

---
**تم تطويره بـ ❤️ للمجتمع العربي**
