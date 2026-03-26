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
  final Map<String, dynamic> _answers = {}; // questionId -> score (1-5) or category ("R", etc)
  bool _isQuizComplete = false;
  QuizResult? _persistedResult;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userGrade => _userGrade;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isQuizComplete => _isQuizComplete;
  double get progress => (_currentQuestionIndex + 1) / totalQuestions;
  QuizResult? get persistedResult => _persistedResult;

  List<Question> get questions => _dynamicQuestions.isNotEmpty ? _dynamicQuestions : ONETData.questions;
  Question get currentQuestion => questions[_currentQuestionIndex];
  int get totalQuestions => questions.length;

  Future<void> startDynamicQuiz() async {
    _isLoading = true;
    notifyListeners();
    try {
      _dynamicQuestions = await ApiService.fetchDynamicQuestions([]);
      _answers.clear();
      _currentQuestionIndex = 0;
      _isQuizComplete = false;
    } catch (e) {
      // Fallback or error handled elsewhere
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

  void answerQuestion(dynamic value) async {
    _answers[currentQuestion.id] = value;
    if (_currentQuestionIndex < questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
      try {
        final resultData = await ApiService.submitQuiz(_answers);
        _persistedResult = QuizResult(
          hollandCode: (resultData['top_categories'] as List).join(''),
          rawScores: Map<String, int>.from(resultData['scores']),
          percentageScores: {}, // Not used by backend return yet, or map if needed
          topPersonalityTypes: List<String>.from(resultData['top_categories']),
          careerGuidance: resultData['career_guidance'],
        );
        _isQuizComplete = true;
        await _saveResultLocally();
      } catch (e) {
        // Handle error
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  QuizResult getResult() {
    if (_persistedResult != null && _answers.isEmpty) return _persistedResult!;

    final rawScores = {
      'R': 0, 'I': 0, 'A': 0, 'S': 0, 'E': 0, 'C': 0
    };

    _answers.forEach((id, score) {
      final question = ONETData.questions.firstWhere((q) => q.id == id);
      final category = question.category as String;
      rawScores[category] = (rawScores[category] ?? 0) + ((score as int) - 1); // 0-4 range
    });

    final percentageScores = <String, double>{};
    rawScores.forEach((key, value) {
      double maxRaw = 5.0 * 4.0;
      percentageScores[key] = (value / maxRaw * 100).clamp(0, 100);
    });

    final sortedKeys = percentageScores.keys.toList()
      ..sort((a, b) => (percentageScores[b] ?? 0).compareTo(percentageScores[a] ?? 0));
    
    final hollandCode = sortedKeys.take(3).join('');
    final topThreeTypes = sortedKeys.take(3).toList();

    return QuizResult(
      hollandCode: hollandCode,
      rawScores: rawScores,
      percentageScores: percentageScores,
      topPersonalityTypes: topThreeTypes,
    );
  }

  Future<void> _saveResultLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final result = getResult();
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_grade', _userGrade);
    await prefs.setString('quiz_result', jsonEncode({
      'hollandCode': result.hollandCode,
      'percentageScores': result.percentageScores,
      'topPersonalityTypes': result.topPersonalityTypes,
      'careerGuidance': result.careerGuidance,
    }));
  }

  Future<void> loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? '';
    _userGrade = prefs.getString('user_grade') ?? '';
    final resultJson = prefs.getString('quiz_result');
    if (resultJson != null) {
      final map = jsonDecode(resultJson);
      _persistedResult = QuizResult(
        hollandCode: map['hollandCode'],
        rawScores: {}, // Not strictly needed for display
        percentageScores: Map<String, double>.from(map['percentageScores'] ?? {}),
        topPersonalityTypes: List<String>.from(map['topPersonalityTypes']),
        careerGuidance: map['careerGuidance'],
      );
      _isQuizComplete = true;
      notifyListeners();
    }
  }

  List<Career> getMatchedCareers(QuizResult result) {
    final careers = List<Career>.from(ONETData.careers);
    careers.sort((a, b) => 
      b.calculateMatchScore(result.percentageScores).compareTo(a.calculateMatchScore(result.percentageScores))
    );
    return careers;
  }

  String getRecommendedStream(QuizResult result) {
    final topCode = result.hollandCode[0];
    final type = ONETData.riasecTypes.firstWhere((t) => t.code == topCode);
    return type.recommendedStream;
  }

  void resetQuiz() async {
    _currentQuestionIndex = 0;
    _answers.clear();
    _isQuizComplete = false;
    _persistedResult = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_result');
    notifyListeners();
  }
}
