import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/career.dart';
import '../theme/app_colors.dart';

class CareerDetailSheet extends StatelessWidget {
  final Career career;
  final int matchScore;

  const CareerDetailSheet({
    super.key, 
    required this.career, 
    required this.matchScore
  });

  @override
  Widget build(BuildContext context) {
    final matchColor = matchScore > 80 ? AppColors.mint : (matchScore > 50 ? AppColors.accent : AppColors.coral);

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Stack(
            children: [
              // Bottom Sheet Content
              ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title & Match
                  Center(
                    child: Column(
                      children: [
                        Text(career.emoji, style: const TextStyle(fontSize: 80)),
                        const SizedBox(height: 16),
                        Text(
                          career.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 28),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: matchColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: matchColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            "$matchScore% Personality Match",
                            style: TextStyle(color: matchColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Description
                  _sectionTitle("What will you do?"),
                  Text(
                    career.description,
                    style: const TextStyle(color: AppColors.textMid, fontSize: 16, height: 1.5),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Education Path (Indian Context)
                  _sectionTitle("How to reach here? 🎓"),
                  _infoCard(
                    title: "Class 11-12 Path",
                    content: "Take ${career.stream} Stream",
                    icon: Icons.school_rounded,
                  ),
                  const SizedBox(height: 12),
                  _infoCard(
                    title: "Subjects needed",
                    content: career.class11Subjects.join(", "),
                    icon: Icons.book_rounded,
                  ),
                  const SizedBox(height: 12),
                   _infoCard(
                    title: "After School",
                    content: career.education,
                    icon: Icons.workspace_premium_rounded,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Success Roadmap (Market Enhancement)
                  _sectionTitle("Your Success Roadmap 🚀"),
                  _roadmapStep(
                    number: "01",
                    title: "Build Foundation",
                    desc: "Focus on ${career.class11Subjects.take(2).join(" & ")} in Class 10.",
                  ),
                  _roadmapStep(
                    number: "02",
                    title: "Higher Secondary",
                    desc: "Choose ${career.stream} Stream in Class 11-12.",
                  ),
                  _roadmapStep(
                    number: "03",
                    title: "Professional Degree",
                    desc: "Prepare for Entrance Exams like ${career.education.split(",").first}.",
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Salary Bar
                  _sectionTitle("Future Earnings (India) 💰"),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Starting", style: TextStyle(color: AppColors.textLight)),
                            Text(career.salary.split(' - ')[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.7,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.mint]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ).animate().shimmer(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Experienced", style: TextStyle(color: AppColors.textLight)),
                            Text(career.salary.split(' - ').length > 1 ? career.salary.split(' - ')[1] : "High", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Skills
                  _sectionTitle("Skills you'll develop ✨"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: career.skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lavender.withValues(alpha: 0.2)),
                      ),
                      child: Text(s, style: const TextStyle(color: AppColors.lavender, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Top Colleges
                  _sectionTitle("Top Colleges in India 🏛️"),
                  ...career.topColleges.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.location_city_rounded, color: AppColors.textMid, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(c, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                      ],
                    ),
                  )),
                  
                  const SizedBox(height: 48),
                  
                  // Big CTA
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Save This Career 🔖"),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
              
              // Close Button
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
    );
  }

  Widget _infoCard({required String title, required String content, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                Text(content, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roadmapStep({required String number, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: AppColors.textMid, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
