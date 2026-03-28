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
  bool _navigating = false; // guard against double-navigation

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        // ── Navigate to CalculatingScreen when quiz is complete ──────────
        // We do this in a post-frame callback so that we're not calling
        // Navigator during a build phase.
        // Also navigate when isLoading AND we are on the last question —
        // that means _finalizeQuiz() has started (last answer submitted).
        final bool lastQuestionSubmitting =
            provider.isLoading &&
            provider.currentQuestionIndex >= provider.totalQuestions - 1;
        if ((provider.isQuizComplete || lastQuestionSubmitting) && !_navigating) {
          _navigating = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const CalculatingScreen()),
              );
            }
          });
        }

        // ── Loading overlay (fetching questions only; submitting is handled
        //    by navigating to CalculatingScreen above) ──────────────────────
        if (provider.isLoading && provider.currentQuestionIndex < provider.totalQuestions - 1) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A2E),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 5,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading your questions...',
                    style: GoogleFonts.dmSans(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Guard: if questions list is empty don't render ────────────────
        if (provider.totalQuestions == 0) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
          );
        }

        final question = provider.currentQuestion;
        final String category = question.category ??
            (question.options?.isNotEmpty == true
                ? question.options![0].category
                : 'R');
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
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
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final availH = constraints.maxHeight;
                                      final emojiFontSize = (availH * 0.14).clamp(36.0, 64.0);
                                      final titleFontSize = (availH * 0.065).clamp(16.0, 24.0);
                                      final vPad = (availH * 0.06).clamp(12.0, 28.0);
                                      return SingleChildScrollView(
                                        padding: EdgeInsets.fromLTRB(24, vPad, 24, 16),
                                        child: Column(
                                          children: [
                                            // Emoji
                                            Text(
                                              question.emoji,
                                              style: TextStyle(fontSize: emojiFontSize),
                                            )
                                                .animate(
                                                    key: ValueKey(
                                                        '${question.id}_emoji'))
                                                .scale(
                                                    duration: 400.ms,
                                                    curve:
                                                        Curves.easeOutBack),

                                            SizedBox(height: availH * 0.05),

                                            // Question Text
                                            Text(
                                              question.text,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.dmSans(
                                                fontSize: titleFontSize,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF1A1A2E),
                                                height: 1.3,
                                              ),
                                            )
                                                .animate(
                                                    key: ValueKey(
                                                        '${question.id}_text'))
                                                .fadeIn(duration: 350.ms)
                                                .slideY(begin: 0.1, end: 0),

                                            const SizedBox(height: 16),

                                            // ── MCQ Options (dynamic quiz) ────
                                            if (question.options != null &&
                                                question.options!.isNotEmpty)
                                              ...question.options!
                                                  .map((opt) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: SizedBox(
                                                          width: double.infinity,
                                                          child: OutlinedButton(
                                                            style: OutlinedButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  const Color(
                                                                      0xFF1A1A2E),
                                                              side: BorderSide(
                                                                color: riasecType
                                                                    .color
                                                                    .withOpacity(
                                                                        0.25),
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                vertical: 13,
                                                                horizontal: 16,
                                                              ),
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFFF8F9FF),
                                                            ),
                                                            onPressed: () {
                                                              HapticFeedback
                                                                  .lightImpact();
                                                              provider.answerQuestion(
                                                                  opt.category);
                                                            },
                                                            child: Text(
                                                              opt.text,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: GoogleFonts
                                                                  .dmSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList()

                                            // ── Likert Scale (static quiz) ────
                                            else
                                              LikertScale(
                                                onSelected: (score) {
                                                  HapticFeedback.lightImpact();
                                                  provider.answerQuestion(score);
                                                },
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate(
                                key: ValueKey('${question.id}_card'))
                            .slideX(
                                begin: 0.15,
                                end: 0,
                                duration: 350.ms,
                                curve: Curves.easeOutCubic)
                            .fadeIn(duration: 350.ms),
                      ),

                      // Bottom personality tagline
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            riasecType.tagline,
                            style: GoogleFonts.dmSans(
                              color: riasecType.color,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          )
                              .animate(key: ValueKey(question.id))
                              .fadeIn(delay: 200.ms),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
