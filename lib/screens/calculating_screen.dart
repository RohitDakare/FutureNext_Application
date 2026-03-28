import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import 'results_screen.dart';

class CalculatingScreen extends StatefulWidget {
  const CalculatingScreen({super.key});

  @override
  State<CalculatingScreen> createState() => _CalculatingScreenState();
}

class _CalculatingScreenState extends State<CalculatingScreen> {
  int _messageIndex = 0;
  final List<String> _messages = [
    "Mapping your personality...",
    "Finding your strengths...",
    "Matching careers for you...",
    "Almost there! 🎉",
  ];
  late Timer _timer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Cycle messages every 600ms
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });

    // Wait for the provider to finish computing the result (isQuizComplete),
    // then navigate. Use a short minimum delay so the animation plays briefly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForResult();
    });
  }

  void _waitForResult() {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    if (provider.isQuizComplete) {
      _goToResults();
    } else {
      // Poll every 300ms until complete, with a safety cap of 30s
      _pollForResult(DateTime.now());
    }
  }

  void _pollForResult(DateTime startTime) {
    if (!mounted || _navigated) return;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted || _navigated) return;
      final provider = Provider.of<QuizProvider>(context, listen: false);
      final elapsed = DateTime.now().difference(startTime);
      if (provider.isQuizComplete) {
        _goToResults();
      } else if (elapsed.inSeconds >= 30) {
        // Safety fallback after 30s — navigate anyway
        _goToResults();
      } else {
        _pollForResult(startTime);
      }
    });
  }

  void _goToResults() {
    if (_navigated || !mounted) return;
    _navigated = true;
    // Ensure minimum 900ms animation time
    final delay = const Duration(milliseconds: 900);
    Future.delayed(delay, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResultsScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.meshGradient,
            ),
          ),
          const DotGridBackground(),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 2),
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .rotate(duration: 2.seconds),
                
                const SizedBox(height: 48),
                
                Text(
                  _messages[_messageIndex],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(key: ValueKey(_messageIndex))
                 .fadeIn(duration: 200.ms)
                 .slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 16),
                
                Text(
                  "Analysing your answers...",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
