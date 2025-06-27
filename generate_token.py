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
    # توليد tokens مختلفة المدة
    room_name = "playground-room"
    participant_name = "flutter-user"
    
    try:
        # Token لمدة 24 ساعة
        token_24h = generate_token(room_name, participant_name, 24)
        print(f"Token (24 ساعة): {token_24h}")
        print()
        
        # Token لمدة أسبوع (168 ساعة)
        token_week = generate_token(room_name, participant_name, 168)
        print(f"Token (أسبوع كامل): {token_week}")
        print()
        
        print(f"Room Name: {room_name}")
        print(f"Participant: {participant_name}")
        print(f"URL: wss://aivoic-tqnojuug.livekit.cloud")
        
    except Exception as e:
        print(f"خطأ في توليد Token: {e}")
