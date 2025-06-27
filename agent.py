from dotenv import load_dotenv
import os
import asyncio
import logging

from livekit import agents
from livekit.agents import AgentSession, Agent, RoomInputOptions
from livekit.plugins import (
    noise_cancellation,
)
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
    try:
        logger.info("🚀 بدء جلسة الوكيل...")
        
        session = AgentSession()

        # إنشاء الوكيل
        assistant = Assistant()
        logger.info("✅ تم إنشاء الوكيل بنجاح")

        # بدء الجلسة
        await session.start(
            room=ctx.room,
            agent=assistant,
            room_input_options=RoomInputOptions(
                video_enabled=False,
                noise_cancellation=noise_cancellation.BVC(),
            ),
        )
        
        logger.info("✅ تم بدء الجلسة بنجاح")

        # الاتصال بالغرفة
        await ctx.connect()
        logger.info("✅ تم الاتصال بالغرفة بنجاح")

        # توليد الرد الأولي
        await session.generate_reply(
            instructions=SESSION_INSTRUCTION,
        )
        
        logger.info("🎉 الوكيل جاهز للاستخدام!")
        
    except Exception as e:
        logger.error(f"❌ خطأ في entrypoint: {e}")
        raise


if __name__ == "__main__":
    import sys
    
    try:
        logger.info("🌟 بدء تشغيل Friday Jarvis Assistant...")
        
        if len(sys.argv) > 1 and sys.argv[1] == "start":
            # تشغيل الوكيل للإنتاج (Railway)
            logger.info("🚀 تشغيل وضع الإنتاج...")
            port = int(os.getenv("PORT", 8081))
            logger.info(f"📡 الاستماع على المنفذ: {port}")
            
            agents.cli.run_app(agents.WorkerOptions(
                entrypoint_fnc=entrypoint,
                host="0.0.0.0",
                port=port,
                # تحسينات الأداء
                num_workers=1,  # تقليل عدد العمال لتوفير الذاكرة
            ))
        else:
            # تشغيل وضع التطوير
            logger.info("🔧 تشغيل وضع التطوير...")
            agents.cli.run_app(agents.WorkerOptions(
                entrypoint_fnc=entrypoint,
                num_workers=1,
            ))
    except KeyboardInterrupt:
        logger.info("⏹️ تم إيقاف الوكيل بواسطة المستخدم")
    except Exception as e:
        logger.error(f"💥 خطأ فادح في التشغيل: {e}")
        sys.exit(1)