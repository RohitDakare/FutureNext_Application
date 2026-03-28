import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../models/career.dart';
import '../data/onet_data.dart';

class QuizProvider with ChangeNotifier {
  String _userName = '';
  String _userGrade = '';
  int _currentQuestionIndex = 0;
  List<Question> _dynamicQuestions = [];

  // questionId -> score (int, 1-5) for Likert, or category string for MCQ
  final Map<String, dynamic> _answers = {};

  bool _isQuizComplete = false;
  QuizResult? _persistedResult;
  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ──────────────────────────────────────
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userGrade => _userGrade;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isQuizComplete => _isQuizComplete;
  String? get errorMessage => _errorMessage;
  double get progress => totalQuestions == 0
      ? 0
      : (_currentQuestionIndex + 1) / totalQuestions;
  QuizResult? get persistedResult => _persistedResult;

  List<Question> get questions =>
      _dynamicQuestions.isNotEmpty ? _dynamicQuestions : ONETData.questions;
  Question get currentQuestion => questions[_currentQuestionIndex];
  int get totalQuestions => questions.length;

  // ── Dynamic Quiz Loading ──────────────────────────
  Future<void> startDynamicQuiz() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _dynamicQuestions = await ApiService.fetchDynamicQuestions([]);
      _answers.clear();
      _currentQuestionIndex = 0;
      _isQuizComplete = false;
    } catch (e) {
      // Silently fall back to static questions — caller handles UI
      _dynamicQuestions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUserProfile(String name, String grade) {
    _userName = name;
    _userGrade = grade;
    notifyListeners();
  }

  // ── Answer & Submit ───────────────────────────────
  /// Records an answer for the current question, advances to next, or
  /// submits the quiz when the last question is answered.
  /// Navigation is driven by listeners watching [isQuizComplete].
  Future<void> answerQuestion(dynamic value) async {
    _answers[currentQuestion.id] = value;

    if (_currentQuestionIndex < questions.length - 1) {
      // Not the last question — just move forward
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      // Last question answered — compute / submit result
      await _finalizeQuiz();
    }
  }

  Future<void> _finalizeQuiz() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Try to get AI-enhanced result from backend
      final resultData = await ApiService.submitQuiz(_answers);

      // Build percentage scores from raw backend scores (if provided)
      final rawFromBackend = resultData['scores'] != null
          ? Map<String, int>.from(resultData['scores'])
          : _computeRawScores();

      final pct = _computePercentages(rawFromBackend);
      final topCats = List<String>.from(resultData['top_categories'] ?? []);

      // If backend didn't return top_categories, derive from pct
      if (topCats.isEmpty) {
        final sorted = pct.keys.toList()
          ..sort((a, b) => (pct[b] ?? 0).compareTo(pct[a] ?? 0));
        topCats.addAll(sorted.take(3));
      }

      _persistedResult = QuizResult(
        hollandCode: topCats.take(3).join(''),
        rawScores: rawFromBackend,
        percentageScores: pct,
        topPersonalityTypes: topCats.take(3).toList(),
        careerGuidance: resultData['career_guidance'],
      );
    } catch (e) {
      // Backend failed — compute locally from answers so user isn't stuck
      _persistedResult = _computeLocalResult();
    }

    await _saveResultLocally();
    _isLoading = false;
    _isQuizComplete = true;
    notifyListeners(); // ← This is what the UI listens to for navigation
  }

  // ── Local Computation (Fallback) ──────────────────
  /// Computes RIASEC scores from the local answer map without any API call.
  QuizResult _computeLocalResult() {
    final raw = _computeRawScores();
    final pct = _computePercentages(raw);
    final sorted = pct.keys.toList()
      ..sort((a, b) => (pct[b] ?? 0).compareTo(pct[a] ?? 0));
    final topThree = sorted.take(3).toList();

    return QuizResult(
      hollandCode: topThree.join(''),
      rawScores: raw,
      percentageScores: pct,
      topPersonalityTypes: topThree,
    );
  }

  /// Tallies raw scores from answers, gracefully handling both static
  /// (Likert int 1-5) and dynamic (category string) question formats.
  Map<String, int> _computeRawScores() {
    final raw = {'R': 0, 'I': 0, 'A': 0, 'S': 0, 'E': 0, 'C': 0};

    _answers.forEach((questionId, answer) {
      if (answer is int) {
        // Likert-scale static quiz — look up the question's category
        try {
          // Try static questions first
          final q = ONETData.questions.firstWhere(
            (q) => q.id == questionId,
            orElse: () => throw StateError('not found'),
          );
          final cat = q.category as String? ?? 'R';
          raw[cat] = (raw[cat] ?? 0) + (answer - 1).clamp(0, 4);
        } catch (_) {
          // Dynamic question with Likert — try to derive from id prefix
          final prefix = _categoryFromId(questionId);
          raw[prefix] = (raw[prefix] ?? 0) + (answer - 1).clamp(0, 4);
        }
      } else if (answer is String && raw.containsKey(answer)) {
        // MCQ — the answer IS the category code (e.g. "R", "I", etc.)
        raw[answer] = (raw[answer] ?? 0) + 4; // full score for selecting
      }
    });

    return raw;
  }

  /// Converts raw ints to 0–100 percentages.
  Map<String, double> _computePercentages(Map<String, int> raw) {
    final pct = <String, double>{};
    // Max per category = 5 questions × 4 points each = 20
    const maxPerCategory = 20.0;
    raw.forEach((k, v) {
      pct[k] = (v / maxPerCategory * 100).clamp(0, 100);
    });
    return pct;
  }

  /// Extracts RIASEC category from a question ID like "r1", "i3", etc.
  String _categoryFromId(String id) {
    if (id.isEmpty) return 'R';
    final prefix = id[0].toUpperCase();
    return {'R', 'I', 'A', 'S', 'E', 'C'}.contains(prefix) ? prefix : 'R';
  }

  // ── Navigation Helper ─────────────────────────────
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // ── Result Getter ─────────────────────────────────
  /// Returns the best available result — persisted (from backend/cache)
  /// if it has percentage scores, otherwise computes locally.
  QuizResult getResult() {
    if (_persistedResult != null &&
        _persistedResult!.percentageScores.isNotEmpty) {
      return _persistedResult!;
    }

    // If persisted result exists but lacks percentages (old cache format),
    // recompute from raw scores
    if (_persistedResult != null && _persistedResult!.rawScores.isNotEmpty) {
      final pct = _computePercentages(_persistedResult!.rawScores);
      final sorted = pct.keys.toList()
        ..sort((a, b) => (pct[b] ?? 0).compareTo(pct[a] ?? 0));
      return QuizResult(
        hollandCode: _persistedResult!.hollandCode,
        rawScores: _persistedResult!.rawScores,
        percentageScores: pct,
        topPersonalityTypes: sorted.take(3).toList(),
        careerGuidance: _persistedResult!.careerGuidance,
      );
    }

    // Compute from live answers if available
    if (_answers.isNotEmpty) {
      return _computeLocalResult();
    }

    // Absolute fallback — empty result
    return QuizResult(
      hollandCode: 'N/A',
      rawScores: {},
      percentageScores: {},
      topPersonalityTypes: [],
    );
  }

  // ── Persistence ───────────────────────────────────
  Future<void> _saveResultLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = getResult();
      await prefs.setString('user_name', _userName);
      await prefs.setString('user_grade', _userGrade);
      await prefs.setString(
        'quiz_result',
        jsonEncode({
          'hollandCode': result.hollandCode,
          'rawScores': result.rawScores,
          'percentageScores': result.percentageScores,
          'topPersonalityTypes': result.topPersonalityTypes,
          'careerGuidance': result.careerGuidance,
        }),
      );
    } catch (_) {
      // Ignore persistence errors — result is still in memory
    }
  }

  Future<void> loadPersistedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? '';
      _userGrade = prefs.getString('user_grade') ?? '';
      final resultJson = prefs.getString('quiz_result');
      if (resultJson != null) {
        final map = jsonDecode(resultJson);
        final rawMap = map['rawScores'];
        final pctMap = map['percentageScores'];

        _persistedResult = QuizResult(
          hollandCode: map['hollandCode'] ?? 'N/A',
          rawScores: rawMap != null ? Map<String, int>.from(rawMap) : {},
          percentageScores:
              pctMap != null ? Map<String, double>.from(pctMap) : {},
          topPersonalityTypes:
              List<String>.from(map['topPersonalityTypes'] ?? []),
          careerGuidance: map['careerGuidance'],
        );
        _isQuizComplete = true;
        notifyListeners();
      }
    } catch (_) {
      // Ignore load errors
    }
  }

  // ── Career Helpers ────────────────────────────────
  List<Career> getMatchedCareers(QuizResult result) {
    final careers = List<Career>.from(ONETData.careers);
    if (result.percentageScores.isEmpty) return careers; // no sort if no scores
    careers.sort((a, b) => b
        .calculateMatchScore(result.percentageScores)
        .compareTo(a.calculateMatchScore(result.percentageScores)));
    return careers;
  }

  String getRecommendedStream(QuizResult result) {
    if (result.hollandCode.isEmpty || result.hollandCode == 'N/A') {
      return 'Science';
    }
    final topCode = result.hollandCode[0];
    final type = ONETData.riasecTypes.firstWhere(
      (t) => t.code == topCode,
      orElse: () => ONETData.riasecTypes[0],
    );
    return type.recommendedStream;
  }

  // ── Reset ─────────────────────────────────────────
  Future<void> resetQuiz() async {
    _currentQuestionIndex = 0;
    _answers.clear();
    _isQuizComplete = false;
    _persistedResult = null;
    _errorMessage = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quiz_result');
    } catch (_) {}
    notifyListeners();
  }
}
