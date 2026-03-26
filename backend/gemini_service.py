import google.generativeai as genai
from config import settings
import json
import re

genai.configure(api_key=settings.gemini_api_key)

# We can use gemini-1.5-flash for general fast generations
model = genai.GenerativeModel("gemini-1.5-flash")

def generate_dynamic_questions(previous_questions: list[str]) -> list[dict]:
    prompt = f"""
    You are an expert career counselor. Generate 5 unique multiple-choice questions for a career interest test.
    Each question should be a scenario or preference question.
    Each question should have 4-6 unique options.
    Each option must be associated with one of the 6 RIASEC categories (Realistic, Investigative, Artistic, Social, Enterprising, Conventional).
    
    Please return ONLY a JSON array of objects.
    Each object must have the following keys:
    "id": a unique string identifier
    "text": the question text (e.g. "What kind of project would you enjoy most?")
    "emoji": a relevant emoji
    "options": an array of objects, each with:
        "text": the option text (e.g. "Repairing a broken engine")
        "category": the category it represents ("R", "I", "A", "S", "E", or "C")

    IMPORTANT: Do NOT repeat any of the following previous questions or very similar concepts:
    {json.dumps(previous_questions)}

    Ensure the response is raw JSON without Markdown formatting backticks.
    """
    try:
        response = model.generate_content(prompt)
        text = response.text.strip()
        if text.startswith("```json"):
            text = text[7:]
        if text.startswith("```"):
            text = text[3:]
        if text.endswith("```"):
            text = text[:-3]
            
        questions = json.loads(text.strip())
        return questions
    except Exception as e:
        print(f"Error generating questions: {e}")
        # Return fallback questions
        return [
            {"id": "fallback_1", "text": "I like to build things with my hands.", "category": "R", "emoji": "🛠️"},
            {"id": "fallback_2", "text": "I enjoy solving complex puzzles.", "category": "I", "emoji": "🧩"},
            {"id": "fallback_3", "text": "I love creating art and design.", "category": "A", "emoji": "🎨"},
            {"id": "fallback_4", "text": "I enjoy helping people learn new things.", "category": "S", "emoji": "🤝"},
            {"id": "fallback_5", "text": "I like to lead teams and projects.", "category": "E", "emoji": "💼"}
        ]

def generate_career_guidance(scores: dict, top_categories: list, recommended_careers: list) -> str:
    careers_text = ", ".join([c.title for c in recommended_careers])
    prompt = f"""
    You are an expert career counselor. A student has just completed a RIASEC career aptitude test.
    Their scores are: Realistic: {scores.get('R', 0)}, Investigative: {scores.get('I', 0)}, Artistic: {scores.get('A', 0)}, Social: {scores.get('S', 0)}, Enterprising: {scores.get('E', 0)}, Conventional: {scores.get('C', 0)}.
    Their top categories are: {', '.join(top_categories)}.
    Based on our database, we matched them with these careers: {careers_text}.

    Provide a short, personalized, and encouraging career guidance summary (about 3-4 paragraphs).
    Highlight what their scores mean about their strengths, why these specific careers might be a good fit, and suggest 2-3 actionable next steps for a high school student to explore these fields.
    Format your response in simple Markdown.
    """
    try:
        response = model.generate_content(prompt)
        return response.text.strip()
    except Exception as e:
        print(f"Error generating guidance: {e}")
        return "Based on your results, you have strong inclinations towards your top categories. Explore the recommended careers above to learn more about potential paths that match your interests!"
