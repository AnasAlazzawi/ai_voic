from dotenv import load_dotenv

from livekit import agents
from livekit.agents import AgentSession, Agent, RoomInputOptions
from livekit.plugins import (
    noise_cancellation,
)
from livekit.plugins import google
from prompts import AGENT_INSTRUCTION, SESSION_INSTRUCTION
from tools import get_weather, search_web
load_dotenv()


class Assistant(Agent):
    def __init__(self) -> None:
        import logging
        logger = logging.getLogger(__name__)
        
        try:
            logger.info("Initializing Assistant...")
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
            logger.info("Assistant initialized successfully")
        except Exception as e:
            logger.error(f"Error initializing Assistant: {e}")
            raise
        


async def entrypoint(ctx: agents.JobContext):
    import logging
    logger = logging.getLogger(__name__)
    
    try:
        logger.info("Initializing agent session...")
        session = AgentSession()

        logger.info("Starting session...")
        await session.start(
            room=ctx.room,
            agent=Assistant(),
            room_input_options=RoomInputOptions(
                # LiveKit Cloud enhanced noise cancellation
                # - If self-hosting, omit this parameter
                # - For telephony applications, use `BVCTelephony` for best results
                video_enabled=False,
                noise_cancellation=noise_cancellation.BVC(),
            ),
        )

        logger.info("Connecting to room...")
        await ctx.connect()

        logger.info("Generating initial reply...")
        await session.generate_reply(
            instructions=SESSION_INSTRUCTION,
        )
        
        logger.info("Agent initialized successfully and ready for connections")
        
    except Exception as e:
        logger.error(f"Error in entrypoint: {e}")
        raise


if __name__ == "__main__":
    import sys
    import logging
    
    # إعداد اللوقينق
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    try:
        logger.info("Starting Friday JARVIS Agent...")
        agents.cli.run_app(agents.WorkerOptions(entrypoint_fnc=entrypoint))
    except Exception as e:
        logger.error(f"Failed to start agent: {e}")
        sys.exit(1)