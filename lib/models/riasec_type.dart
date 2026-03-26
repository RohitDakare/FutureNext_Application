import 'package:flutter/material.dart';

class RIASECType {
  final String code; // R, I, A, S, E, C
  final String name;
  final String emoji;
  final String tagline;
  final String description;
  final List<String> traits;
  final List<String> activities;
  final String recommendedStream; // Science / Commerce / Arts / Vocational
  final List<String> famousExamples;
  final Color color;

  RIASECType({
    required this.code,
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.description,
    required this.traits,
    required this.activities,
    required this.recommendedStream,
    required this.famousExamples,
    required this.color,
  });
}
