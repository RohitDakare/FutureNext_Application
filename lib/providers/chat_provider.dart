import 'package:flutter/material.dart';
import '../data/onet_data.dart';
import '../models/quiz_result.dart';
import '../models/career.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  void addMessage(String text, bool isUser) {
    _messages.add(ChatMessage(
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  Future<void> getAIResponse(String userQuery, QuizResult? result, List<Career> matchedCareers, String userName) async {
    _isTyping = true;
    notifyListeners();

    // Simulate AI thinking
    await Future.delayed(const Duration(seconds: 1));

    String response = _generateOfflineResponse(userQuery, result, matchedCareers, userName);

    _messages.add(ChatMessage(
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    _isTyping = false;
    notifyListeners();
  }

  String _generateOfflineResponse(String query, QuizResult? result, List<Career> matchedCareers, String name) {
    final q = query.toLowerCase();
    
    if (result == null || matchedCareers.isEmpty) return "Hi $name! I'm ready to help once you finish the career quiz!";

    final topType = result.topPersonalityTypes.first;
    final typeInfo = ONETData.riasecTypes.firstWhere((t) => t.code == topType);
    final topCareer = matchedCareers.first;

    // Smart Responses based on keyword detection
    if (q.contains('hello') || q.contains('hi')) {
      return "Hi $name! I'm FutureNex AI. Based on your $topType (${typeInfo.name}) personality, you're a perfect match for ${topCareer.title}. How can I help you today?";
    } else if (q.contains('career') || q.contains('job')) {
      return "Your top career matches are: ${matchedCareers.take(3).map((c) => c.title).join(', ')}. These match your interest in ${typeInfo.name} activities!";
    } else if (q.contains('salary') || q.contains('earn')) {
      return "For a ${topCareer.title}, the typical salary in India is around ${topCareer.salary}.";
    } else if (q.contains('study') || q.contains('subject') || q.contains('stream')) {
      return "To become a ${topCareer.title}, you should choose the ${topCareer.stream} stream in Class 11. Focus on subjects like ${topCareer.class11Subjects.join(', ')}.";
    } else if (q.contains('why') || q.contains('reason')) {
      return "You scored highest in ${typeInfo.name} (${result.percentageScores[topType]}%). This means you naturally enjoy ${typeInfo.description.toLowerCase()}. ${topCareer.title} is an ideal way to use those strengths!";
    } else if (q.contains('thank')) {
      return "You're welcome, $name! I'm here to help you reach your goals. Anything else?";
    }

    return "That's a great question, $name! As a ${typeInfo.name} personality, you might want to look into the education path: ${topCareer.education}. Could you tell me more about what interests you specifically?";
  }
}
