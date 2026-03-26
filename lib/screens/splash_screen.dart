import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import 'onboarding_screen.dart';
import 'results_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        final provider = context.read<QuizProvider>();
        final target = provider.isQuizComplete ? const ResultsScreen() : const OnboardingScreen();
        
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => target,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark Navy Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.meshGradient,
            ),
          ),
          
          // Animated Dot Grid Overlay
          const DotGridBackground(),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Compass Logo
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🧭',
                      style: TextStyle(fontSize: 80),
                    ),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .boxShadow(
                  begin: const BoxShadow(color: Colors.transparent, blurRadius: 0),
                  end: BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                )
                .animate()
                .scale(
                  duration: 1000.ms,
                  curve: Curves.elasticOut,
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(1.0, 1.0),
                ),
                
                const SizedBox(height: 32),
                
                // App Name with Fade + Slide Up
                Text(
                  'Future Next',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 800.ms,
                  delay: 400.ms,
                  curve: Curves.easeOutCubic,
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  'Find the career made for YOU',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms, delay: 800.ms),
                
                const SizedBox(height: 48),
                
                // Powered by O*NET badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    'Powered by O*NET',
                    style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
          
          // Animated Loading Dots at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                    shape: BoxShape.circle,
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .scale(duration: 600.ms, delay: (index * 200).ms, begin: const Offset(1, 1), end: const Offset(1.5, 1.5))
                 .then()
                 .scale(duration: 600.ms);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
