import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/question.dart';

class GeminiService {
  // ── Gemini API Key (same key as backend .env) ──────────────────────────
  static const String _apiKey = 'AIzaSyA086YLj16bi1myVKczM7_D3TYMcZOD61Q';

  static GenerativeModel? _model;

  static GenerativeModel _getModel() {
    _model ??= GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 1.2, // higher temp = more variety
      ),
    );
    return _model!;
  }

  /// Generates 25 unique RIASEC MCQ questions via Gemini.
  /// Returns null on failure so caller can decide the fallback.
  static Future<List<Question>?> generateQuizQuestions() async {
    final prompt = '''
You are an expert career counselor for Indian high school students (Class 10).
Generate exactly 25 unique, engaging multiple-choice questions for a RIASEC career interest test.

Requirements:
- Draw from varied real-life scenarios: tech, arts, sports, science, nature, finance, social work, daily life.
- Each question must have exactly 4 answer options.
- Each option is mapped to exactly one RIASEC code: R (Realistic/Builder), I (Investigative/Thinker), A (Artistic/Creator), S (Social/Helper), E (Enterprising/Leader), C (Conventional/Organiser).
- Distribute questions so all 6 codes are well represented.
- Questions should be scenario-based, not just "Would you like...".
- Use relatable Indian context where fitting.
- Randomness seed: ${DateTime.now().millisecondsSinceEpoch}

Return ONLY a raw JSON array. No markdown. No explanation. No backticks.
Each element must have:
{
  "id": "unique_string",
  "text": "question text",
  "emoji": "relevant emoji",
  "options": [
    { "text": "option text", "category": "R|I|A|S|E|C" },
    { "text": "option text", "category": "R|I|A|S|E|C" },
    { "text": "option text", "category": "R|I|A|S|E|C" },
    { "text": "option text", "category": "R|I|A|S|E|C" }
  ]
}
''';

    try {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      String? text = response.text?.trim();
      if (text == null || text.isEmpty) return null;

      // Strip markdown fences just in case
      if (text.startsWith('```json')) text = text.substring(7);
      if (text.startsWith('```')) text = text.substring(3);
      if (text.endsWith('```')) text = text.substring(0, text.length - 3);
      text = text.trim();

      final List<dynamic> parsed = jsonDecode(text);
      final questions = parsed.map<Question>((q) {
        final opts = (q['options'] as List).map<QuestionOption>((o) {
          return QuestionOption(
            text: o['text'] as String,
            category: o['category'] as String,
          );
        }).toList();
        return Question(
          id: q['id'] as String,
          text: q['text'] as String,
          emoji: q['emoji'] as String? ?? '❓',
          options: opts,
        );
      }).toList();

      return questions.take(25).toList();
    } catch (e) {
      debugPrint('🔴 GeminiService.generateQuizQuestions failed: $e');
      return null;
    }
  }

  /// Generates career guidance text for a completed quiz result.
  static Future<String?> generateCareerGuidance({
    required Map<String, dynamic> scores,
    required List<String> topCategories,
    required List<String> careerTitles,
  }) async {
    final guidancePrompt = '''
You are a warm, expert career counselor. A Class 10 Indian student just completed a RIASEC career aptitude test.

Their RIASEC scores: Realistic=${scores['R'] ?? 0}, Investigative=${scores['I'] ?? 0}, Artistic=${scores['A'] ?? 0}, Social=${scores['S'] ?? 0}, Enterprising=${scores['E'] ?? 0}, Conventional=${scores['C'] ?? 0}.
Top personality types (Holland Codes): ${topCategories.join(', ')}.
Matched careers: ${careerTitles.take(3).join(', ')}.

Write a personalized career guidance summary (~300 words) in clean Markdown with:
1. **Your Strengths** – acknowledge their unique trait combo
2. **Why These Careers Fit You** – explain the match with top 2-3 careers
3. **Recommended Stream in Class 11/12** – specific streams & subjects
4. **3 Action Steps** – concrete things they can do NOW (courses, projects, competitions)

Use an encouraging, aspirational tone. Use bold headings and bullet points.
''';

    try {
      final textModel = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
      );
      final response =
          await textModel.generateContent([Content.text(guidancePrompt)]);
      return response.text?.trim();
    } catch (e) {
      debugPrint('🔴 GeminiService.generateCareerGuidance failed: $e');
      return null;
    }
  }
}
