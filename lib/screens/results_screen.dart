import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../data/onet_data.dart';
import '../widgets/radar_chart_widget.dart';
import '../widgets/riasec_card.dart';
import 'chat_screen.dart';
import 'quiz_screen.dart';
import 'careers_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final result = provider.getResult();
    final stream = provider.getRecommendedStream(result);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        "Your Holland Code",
                        style: GoogleFonts.dmSans(
                          color: const Color(0xFF667788),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(),

                      const SizedBox(height: 16),

                      // Holland Code Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.25),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          result.hollandCode,
                          style: GoogleFonts.dmSans(
                            color: AppColors.accent,
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                          ),
                        ),
                      ).animate()
                       .scale(duration: 800.ms, curve: Curves.elasticOut)
                       .shimmer(duration: 2.seconds, delay: 1.seconds),

                      const SizedBox(height: 24),

                      if (provider.userName.isNotEmpty)
                        Text(
                          "CAREER REPORT FOR ${provider.userName.toUpperCase()}",
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF1A1A2E).withOpacity(0.4),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 2.0,
                          ),
                        ).animate().fadeIn(),

                      const SizedBox(height: 8),

                      Text(
                        "Your Personal Holland Code",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A2E),
                          fontSize: 28,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "This means you are a ${result.topPersonalityTypes.map((code) => ONETData.riasecTypes.firstWhere((t) => t.code == code).name).join('-')} personality!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 17,
                          color: const Color(0xFF1A1A2E),
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Radar Chart
                SizedBox(
                  height: 320,
                  child: const RadarChartWidget().animate().fadeIn(delay: 600.ms),
                ),

                const SizedBox(height: 40),

                // AI Guidance Card (if available)
                if (result.careerGuidance != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF1A1A2E).withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded, color: AppColors.accent),
                              const SizedBox(width: 8),
                              Text(
                                "AI Personalized Guidance",
                                style: GoogleFonts.dmSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          MarkdownBody(
                            data: result.careerGuidance!,
                            styleSheet: MarkdownStyleSheet(
                              p: GoogleFonts.dmSans(
                                fontSize: 15,
                                height: 1.5,
                                color: const Color(0xFF445566),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                if (result.careerGuidance != null) const SizedBox(height: 32),

                // TOP 3 Types Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: List.generate(result.topPersonalityTypes.length > 3 ? 3 : result.topPersonalityTypes.length, (index) {
                      final code = result.topPersonalityTypes[index];
                      final type = ONETData.riasecTypes.firstWhere((t) => t.code == code, orElse: () => ONETData.riasecTypes[0]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RIASECCard(type: type),
                      ).animate().fadeIn(delay: (800 + index * 200).ms).slideX(begin: 0.1, end: 0);
                    }),
                  ),
                ),

                const SizedBox(height: 32),

                // Stream Recommendation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.accent.withOpacity(0.25)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "🎓 Recommended Stream",
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          stream,
                          style: GoogleFonts.dmSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Based on your dominant personality type, this stream will help you excel and stay happy in your studies!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF667788),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 1400.ms).scale(),

                const SizedBox(height: 40),

                // CTA Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CareersScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A2E),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(
                            "Explore Your Careers ✨",
                            style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          provider.resetQuiz();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const QuizScreen()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded, color: Color(0xFF667788)),
                        label: Text("Retake Quiz",
                          style: GoogleFonts.dmSans(color: const Color(0xFF667788), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 1600.ms),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [AppColors.accent, AppColors.mint, AppColors.coral, AppColors.lavender],
            ),
          ),

          // Share Button
          Positioned(
            top: 48,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.share_rounded, color: Color(0xFF1A1A2E)),
                onPressed: () {
                  final nameStr = provider.userName.isNotEmpty ? "${provider.userName}'s" : "my";
                  Share.share(
                    "Hey! $nameStr Holland personality code is ${result.hollandCode} on FutureNex! Analysis: ${result.topPersonalityTypes.map((c) => ONETData.riasecTypes.firstWhere((t) => t.code == c).name).join('-')}. Check it out!",
                  );
                },
              ),
            ).animate().fadeIn(delay: 2000.ms),
          ),
        ],
      ),
      // Ask AI Assistant FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: const ChatScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1A1A2E),
        icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.accent),
        label: Text(
          "Ask AI Assistant",
          style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ).animate().scale(delay: 2500.ms, curve: Curves.bounceOut),
    );
  }
}
