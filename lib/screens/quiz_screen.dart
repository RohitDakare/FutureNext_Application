import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../data/onet_data.dart';
import '../widgets/likert_scale.dart';
import '../widgets/animated_progress_bar.dart';
import 'calculating_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);

    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFFFB627), strokeWidth: 5),
              SizedBox(height: 24),
              Text(
                'Loading your questions...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final question = provider.currentQuestion;
    final String category = question.category ?? (question.options?.isNotEmpty == true ? question.options![0].category : 'R');
    final riasecType = ONETData.riasecTypes.firstWhere(
      (t) => t.code == category,
      orElse: () => ONETData.riasecTypes[0],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: AppBar(
        backgroundColor: riasecType.color,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => provider.previousQuestion(),
        ),
        title: Text(
          riasecType.name,
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${provider.currentQuestionIndex + 1}/${provider.totalQuestions}',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Colored progress bar
          AnimatedProgressBar(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  // Main Question Card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          children: [
                            // Colored top strip
                            Container(
                              height: 10,
                              color: riasecType.color,
                            ),

                            // Question content
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                                child: Column(
                                  children: [
                                    // Emoji
                                    Text(
                                      question.emoji,
                                      style: const TextStyle(fontSize: 56),
                                    ).animate(key: ValueKey('${question.id}_emoji'))
                                     .scale(duration: 400.ms, curve: Curves.easeOutBack),

                                    const SizedBox(height: 20),

                                    // Question Text
                                    Text(
                                      question.text,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1A1A2E),
                                        height: 1.3,
                                      ),
                                    ).animate(key: ValueKey('${question.id}_text'))
                                     .fadeIn(duration: 350.ms)
                                     .slideY(begin: 0.1, end: 0),

                                    const SizedBox(height: 8),

                                    // Divider before options
                                    const SizedBox(height: 4),

                                    // Likert options or MC options
                                    if (question.options != null && question.options!.isNotEmpty)
                                      // MC Options for Dynamic Quiz
                                      ...question.options!.map((opt) => Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(0xFF1A1A2E),
                                              side: BorderSide(
                                                color: riasecType.color.withOpacity(0.25),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal: 20,
                                              ),
                                              backgroundColor: const Color(0xFFF8F9FF),
                                            ),
                                            onPressed: () {
                                              HapticFeedback.lightImpact();
                                              final navigator = Navigator.of(context);
                                              Future.delayed(const Duration(milliseconds: 200), () {
                                                if (mounted) {
                                                  provider.answerQuestion(opt.category);
                                                  if (provider.isQuizComplete) {
                                                    navigator.pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) => const CalculatingScreen(),
                                                      ),
                                                    );
                                                  }
                                                }
                                              });
                                            },
                                            child: Text(
                                              opt.text,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )).toList()
                                    else
                                      // Likert Scale for Static Quiz
                                      LikertScale(
                                        onSelected: (score) {
                                          HapticFeedback.lightImpact();
                                          final navigator = Navigator.of(context);
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            if (mounted) {
                                              provider.answerQuestion(score);
                                              if (provider.isQuizComplete) {
                                                navigator.pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) => const CalculatingScreen(),
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate(key: ValueKey('${question.id}_card'))
                     .slideX(begin: 0.15, end: 0, duration: 350.ms, curve: Curves.easeOutCubic)
                     .fadeIn(duration: 350.ms),
                  ),

                  // Bottom personality tagline
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      riasecType.tagline,
                      style: GoogleFonts.dmSans(
                        color: riasecType.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ).animate(key: ValueKey(question.id)).fadeIn(delay: 200.ms),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
