import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/career_card.dart';
import '../widgets/career_detail_sheet.dart';
import 'onboarding_screen.dart';

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  String _selectedStream = 'All';
  final List<String> _filters = ['All', 'Science', 'Commerce', 'Arts'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final result = provider.getResult();
    final allCareers = provider.getMatchedCareers(result);

    final filteredCareers = _selectedStream == 'All'
        ? allCareers
        : allCareers.where((c) => c.stream == _selectedStream).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: CustomScrollView(
        slivers: [
          // Dark Navy Collapsing Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A2E),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A1A2E), Color(0xFF2D3250)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Based on your ${result.hollandCode} personality',
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Careers Made\nFor You ✨',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              height: 72,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedStream == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedStream = filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1A1A2E) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF1A1A2E) : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isSelected) ...[
                              const Icon(Icons.check, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              filter,
                              style: GoogleFonts.dmSans(
                                color: isSelected ? Colors.white : const Color(0xFF445566),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Career Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final career = filteredCareers[index];
                  final matchScore = career.calculateMatchScore(result.percentageScores);

                  return CareerCard(
                    career: career,
                    matchScore: matchScore.toInt(),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CareerDetailSheet(
                          career: career,
                          matchScore: matchScore.toInt(),
                        ),
                      );
                    },
                  ).animate().fadeIn(delay: (index * 80).ms).scale(delay: (index * 80).ms);
                },
                childCount: filteredCareers.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      // Retake Quiz FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          provider.resetQuiz();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            (route) => false,
          );
        },
        backgroundColor: const Color(0xFF1A1A2E),
        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        label: Text(
          "Retake Quiz",
          style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ).animate().fadeIn(delay: 1.seconds),
    );
  }
}
