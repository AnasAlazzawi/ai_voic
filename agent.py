from dotenv import load_dotenv
import os
import asyncio
import logging
import time

from livekit import agents
from livekit.agents import AgentSession, Agent, RoomInputOptions
# استيراد تسكين الضوضاء مع التعامل مع الأخطاء
try:
    from livekit.plugins import noise_cancellation
    NOISE_CANCELLATION_AVAILABLE = True
except ImportError:
    NOISE_CANCELLATION_AVAILABLE = False
    logging.warning("⚠️ Noise cancellation plugin غير متوفر")

from livekit.plugins import google
from prompts import AGENT_INSTRUCTION, SESSION_INSTRUCTION
from tools import get_weather, search_web

load_dotenv()

# إعداد نظام السجلات
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Assistant(Agent):
    def __init__(self) -> None:
        super().__init__(
            instructions=AGENT_INSTRUCTION,
            llm=google.beta.realtime.RealtimeModel(
                voice="Charon",
                temperature=0.8,
            ),
            tools=[
                get_weather,
                search_web
            ],
        )


async def entrypoint(ctx: agents.JobContext):
    """نقطة دخول محسنة مع إدارة أفضل للاتصالات"""
    try:
        logger.info("🚀 بدء جلسة الوكيل...")
        logger.info(f"🏠 الغرفة: {ctx.room.name}")
        logger.info(f"👤 المشاركين الحاليين: {len(ctx.room.remote_participants)}")
        
        # إعداد مستمعي أحداث الغرفة
        @ctx.room.on("participant_connected")
        def on_participant_connected(participant):
            logger.info(f"👋 مشارك جديد انضم: {participant.identity}")

        @ctx.room.on("participant_disconnected") 
        def on_participant_disconnected(participant):
            logger.info(f"👋 مشارك غادر: {participant.identity}")
            # لا نغلق الجلسة، فقط نسجل الحدث

        session = AgentSession()

        # إنشاء الوكيل
        assistant = Assistant()
        logger.info("✅ تم إنشاء الوكيل بنجاح")

        # بدء الجلسة مع خيارات محسنة
        room_options = RoomInputOptions(
            video_enabled=False,
            auto_subscribe=True,  # الاشتراك التلقائي في المقاطع
        )
        
        # إضافة تسكين الضوضاء إذا كان متوفراً
        if NOISE_CANCELLATION_AVAILABLE:
            try:
                room_options.noise_cancellation = noise_cancellation.BVC()
                logger.info("✅ تم تفعيل تسكين الضوضاء")
            except Exception as e:
                logger.warning(f"⚠️ لا يمكن تفعيل تسكين الضوضاء: {e}")
        
        await session.start(
            room=ctx.room,
            agent=assistant,
            room_input_options=room_options,
        )
        
        logger.info("✅ تم بدء الجلسة بنجاح")

        # الاتصال بالغرفة
        await ctx.connect()
        logger.info("✅ تم الاتصال بالغرفة بنجاح")

        # انتظار المشاركين أو الاستمرار إذا كانوا موجودين
        if len(ctx.room.remote_participants) == 0:
            logger.info("⏳ انتظار انضمام المشاركين...")
        
        # توليد الرد الأولي عند وجود مشاركين
        if len(ctx.room.remote_participants) > 0:
            await session.generate_reply(
                instructions=SESSION_INSTRUCTION,
            )
        
        logger.info("🎉 الوكيل جاهز للاستخدام!")
        
        # البقاء نشطاً والاستمرار في الاستماع
        try:
            # انتظار إلى ما لا نهاية بدلاً من الإغلاق
            while True:
                await asyncio.sleep(1)
                # التحقق من حالة الجلسة بشكل دوري
                if not session or session.closed:
                    logger.warning("⚠️ الجلسة مغلقة، محاولة إعادة التشغيل...")
                    break
        except asyncio.CancelledError:
            logger.info("🔄 تم إلغاء المهمة")
        
    except Exception as e:
        logger.error(f"❌ خطأ في entrypoint: {e}")
        # لا نرفع الخطأ، بل نسجله فقط لمنع إغلاق السيرفر
        logger.info("🔄 سيتم إعادة تشغيل الوكيل تلقائياً...")


if __name__ == "__main__":
    import sys
    import signal
    
    logger.info("🌟 بدء تشغيل Friday Jarvis Assistant...")
    
    # إعداد معالج إشارات للإغلاق النظيف
    def signal_handler(signum, frame):
        logger.info("⏹️ تم استقبال إشارة الإغلاق")
        sys.exit(0)
    
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    try:
        if len(sys.argv) > 1 and sys.argv[1] == "start":
            # تشغيل الوكيل للإنتاج (Railway)
            logger.info("� تشغيل وضع الإنتاج...")
            
            # تشغيل مع إعادة التشغيل التلقائي
            while True:
                try:
                    agents.cli.run_app(agents.WorkerOptions(
                        entrypoint_fnc=entrypoint,
                    ))
                except Exception as e:
                    logger.error(f"💥 خطأ في تشغيل الوكيل: {e}")
                    logger.info("🔄 إعادة تشغيل الوكيل خلال 3 ثوان...")
                    time.sleep(3)
        else:
            # تشغيل وضع التطوير
            logger.info("🔧 تشغيل وضع التطوير...")
            agents.cli.run_app(agents.WorkerOptions(
                entrypoint_fnc=entrypoint,
            ))
    except KeyboardInterrupt:
        logger.info("⏹️ تم إيقاف الوكيل بواسطة المستخدم")
    except Exception as e:
        logger.error(f"💥 خطأ فادح في التشغيل: {e}")
        sys.exit(1)