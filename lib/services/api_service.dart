import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  // static const String baseUrl = "https://future-next.onrender.com/api";
  // static const String baseUrl = "https://future-next.onrender.com/api";
  static const String baseUrl = "https://futurenext-application.onrender.com/api";

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    final headers = {"Content-Type": "application/json"};
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  static Future<Map<String, dynamic>> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? "Signup failed");
    }
  }

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      if (token == null) {
        throw Exception("Invalid server response: token not found");
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      return token;
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? data['detail'] ?? "Login failed");
      } catch (e) {
        throw Exception("Login failed: ${response.statusCode} - ${response.body}");
      }
    }
  }

  static Future<List<Question>> fetchDynamicQuestions(List<String> previousQuestions) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse("$baseUrl/questions/generate"),
      headers: headers,
      body: jsonEncode({"previous_questions": previousQuestions}),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((q) => Question(
        id: q['id'],
        text: q['text'],
        emoji: q['emoji'],
        options: (q['options'] as List).map((o) => QuestionOption(
          text: o['text'],
          category: o['category'],
        )).toList(),
      )).toList();
    } else {
      throw Exception("Failed to load dynamic questions");
    }
  }

  static Future<Map<String, dynamic>> submitQuiz(Map<String, dynamic> answers) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse("$baseUrl/quiz/submit"),
      headers: headers,
      body: jsonEncode({"answers": answers}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to submit quiz");
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
