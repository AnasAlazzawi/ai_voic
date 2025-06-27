import logging
from livekit.agents import function_tool, RunContext
import requests

# استيراد DuckDuckGo search مع التعامل مع الأخطاء
try:
    from langchain_community.tools import DuckDuckGoSearchRun
    LANGCHAIN_AVAILABLE = True
except ImportError:
    LANGCHAIN_AVAILABLE = False
    logging.warning("⚠️ langchain_community غير متوفر، سيتم استخدام البحث البديل")

try:
    from duckduckgo_search import DDGS
    DDGS_AVAILABLE = True
except ImportError:
    DDGS_AVAILABLE = False
    logging.warning("⚠️ duckduckgo-search غير متوفر")

@function_tool()
async def get_weather(
    context: RunContext,  # type: ignore
    city: str) -> str:
    """
    Get the current weather for a given city.
    """
    try:
        response = requests.get(
            f"https://wttr.in/{city}?format=3")
        if response.status_code == 200:
            logging.info(f"Weather for {city}: {response.text.strip()}")
            return response.text.strip()   
        else:
            logging.error(f"Failed to get weather for {city}: {response.status_code}")
            return f"Could not retrieve weather for {city}."
    except Exception as e:
        logging.error(f"Error retrieving weather for {city}: {e}")
        return f"An error occurred while retrieving weather for {city}." 

@function_tool()
async def search_web(
    context: RunContext,  # type: ignore
    query: str) -> str:
    """
    Search the web using DuckDuckGo.
    """
    try:
        # محاولة استخدام langchain_community أولاً
        if LANGCHAIN_AVAILABLE:
            results = DuckDuckGoSearchRun().run(tool_input=query)
            logging.info(f"Search results for '{query}': {results}")
            return results
        
        # استخدام duckduckgo-search كبديل
        elif DDGS_AVAILABLE:
            with DDGS() as ddgs:
                results = list(ddgs.text(query, max_results=5))
                if results:
                    formatted_results = []
                    for result in results:
                        formatted_results.append(f"• {result.get('title', 'No title')}: {result.get('body', 'No description')}")
                    
                    final_result = "\n".join(formatted_results)
                    logging.info(f"Search results for '{query}': {final_result}")
                    return final_result
                else:
                    return f"لم يتم العثور على نتائج للبحث عن '{query}'"
        
        # البحث البديل باستخدام API مباشر
        else:
            logging.warning("استخدام البحث البديل المحدود")
            return f"عذراً، البحث غير متوفر حالياً للاستعلام: '{query}'"
            
    except Exception as e:
        logging.error(f"Error searching the web for '{query}': {e}")
        return f"حدث خطأ أثناء البحث عن '{query}'. يرجى المحاولة مرة أخرى."