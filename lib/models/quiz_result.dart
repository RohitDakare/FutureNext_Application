class QuizResult {
  final String hollandCode;
  final Map<String, int> rawScores;
  final Map<String, double> percentageScores;
  final List<String> topPersonalityTypes;
  final String? careerGuidance;

  QuizResult({
    required this.hollandCode,
    required this.rawScores,
    required this.percentageScores,
    required this.topPersonalityTypes,
    this.careerGuidance,
  });
}
