import 'package:flutter/material.dart';
import '../models/career.dart';
import '../theme/app_colors.dart';

class CareerCard extends StatelessWidget {
  final Career career;
  final int matchScore;
  final VoidCallback onTap;

  const CareerCard({
    super.key,
    required this.career,
    required this.matchScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final matchColor = matchScore > 80 ? AppColors.mint : (matchScore > 50 ? AppColors.accent : AppColors.coral);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Icon/Emoji Background
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Center(
                      child: Text(
                        career.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  
                  // Match Score Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: matchColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: matchColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        '$matchScore% Match',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    career.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(
                        career.growth,
                        style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Stream Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStreamColor(career.stream).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      career.stream,
                      style: TextStyle(
                        color: _getStreamColor(career.stream),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStreamColor(String stream) {
    if (stream == 'Science') return AppColors.mint;
    if (stream == 'Commerce') return AppColors.accent;
    return AppColors.lavender;
  }
}
