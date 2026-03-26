import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';

class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<QuizProvider>(context).progress;
    
    return Container(
      width: double.infinity,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            width: MediaQuery.of(context).size.width * progress,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.mint],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
