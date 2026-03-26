class Career {
  final String title;
  final String code; // O*NET code or internal identifier
  final String emoji;
  final String description;
  final String stream; // Science / Commerce / Arts
  final String salary; // ₹ Indian format
  final String growth; // % with trend
  final String education; // Exact Indian path
  final List<String> class11Subjects;
  final List<String> riasecCodes;
  final List<String> skills;
  final List<String> topColleges;
  final bool brightOutlook;

  Career({
    required this.title,
    required this.code,
    required this.emoji,
    required this.description,
    required this.stream,
    required this.salary,
    required this.growth,
    required this.education,
    required this.class11Subjects,
    required this.riasecCodes,
    required this.skills,
    required this.topColleges,
    this.brightOutlook = false,
  });

  double calculateMatchScore(Map<String, double> userScores) {
    // Primary code: 50 pts, Secondary: 30 pts, Tertiary: 20 pts
    double score = 0;
    
    for (int i = 0; i < riasecCodes.length; i++) {
      String code = riasecCodes[i];
      double userScore = userScores[code] ?? 0; // 0-100%
      
      if (i == 0) {
        score += userScore * 0.5;
      } else if (i == 1) {
        score += userScore * 0.3;
      } else if (i == 2) {
        score += userScore * 0.2;
      }
    }
    
    return score.clamp(0, 100);
  }
}
