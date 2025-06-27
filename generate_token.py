"""
Token Generator للاتصال من Flutter إلى LiveKit
"""
import jwt
import time
import os
from dotenv import load_dotenv

load_dotenv()

def generate_token(room_name: str, participant_name: str, duration_hours: int = 24):
    """
    توليد JWT token للاتصال بـ LiveKit مع صلاحية أطول
    """
    api_key = os.getenv("LIVEKIT_API_KEY")
    api_secret = os.getenv("LIVEKIT_API_SECRET")
    
    if not api_key or not api_secret:
        raise ValueError("LIVEKIT_API_KEY و LIVEKIT_API_SECRET مطلوبان في ملف .env")
    
    # إعداد JWT payload
    now = int(time.time())
    exp = now + (duration_hours * 3600)  # تحويل الساعات إلى ثوانٍ
    payload = {
        "iss": api_key,
        "exp": exp,
        "nbf": now - 10,    # صالح من 10 ثوانٍ مضت
        "sub": participant_name,
        "video": {
            "room": room_name,
            "roomJoin": True,
            "canPublish": True,
            "canSubscribe": True,
        }
    }
    
    # إنشاء JWT token
    token = jwt.encode(payload, api_secret, algorithm="HS256")
    
    # طباعة معلومات Token
    from datetime import datetime
    exp_datetime = datetime.fromtimestamp(exp)
    print(f"Token صالح لمدة: {duration_hours} ساعة")
    print(f"ينتهي في: {exp_datetime}")
    
    return token

if __name__ == "__main__":
    # توليد token لـ Railway deployment
    room_name = "friday-jarvis-room"
    participant_name = "railway-user"
    
    try:
        # Token لمدة سنة (8760 ساعة) للنشر على Railway
        duration_hours = 8760  # سنة كاملة
        token_long = generate_token(room_name, participant_name, duration_hours)
        print(f"✅ Token تم توليده بنجاح!")
        print(f"📁 Room: {room_name}")
        print(f"👤 Participant: {participant_name}")
        print(f"🔗 URL: wss://aivoic-tqnojuug.livekit.cloud")
        print(f"⏰ صالح لمدة: {duration_hours} ساعة (سنة كاملة)")
        print(f"🎯 Token: {token_long}")
        
        # حفظ Token في ملف للاستخدام مع Flutter
        token_info = f"""# Flutter Integration Token
# Generated: {time.strftime('%Y-%m-%d %H:%M:%S')}
# Valid for: {duration_hours} hours (1 year)

final String _url = 'wss://aivoic-tqnojuug.livekit.cloud';
final String _token = '{token_long}';
final String _room = '{room_name}';
"""
        
        with open('token_info.dart', 'w', encoding='utf-8') as f:
            f.write(token_info)
        
        print("\n💾 Token محفوظ في ملف: token_info.dart")
        print("🚀 جاهز لبدء تشغيل الوكيل...")
        
    except Exception as e:
        print(f"❌ خطأ في توليد Token: {e}")
        exit(1)
