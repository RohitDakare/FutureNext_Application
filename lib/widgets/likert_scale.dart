import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LikertScale extends StatefulWidget {
  final Function(int) onSelected;

  const LikertScale({super.key, required this.onSelected});

  @override
  State<LikertScale> createState() => _LikertScaleState();
}

class _LikertScaleState extends State<LikertScale> {
  int? _selectedIndex;

  final List<LikertOption> _options = [
    LikertOption(emoji: '😣', label: 'Not at all', score: 1),
    LikertOption(emoji: '😕', label: 'Not really', score: 2),
    LikertOption(emoji: '😐', label: 'Maybe', score: 3),
    LikertOption(emoji: '🙂', label: 'Yes!', score: 4),
    LikertOption(emoji: '😍', label: 'Absolutely!', score: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_options.length, (index) {
        final option = _options[index];
        final isSelected = _selectedIndex == index;
        final isLast = index == _options.length - 1;

        return InkWell(
          onTap: () {
            setState(() => _selectedIndex = index);
            widget.onSelected(option.score);
            Future.delayed(const Duration(milliseconds: 350), () {
              if (mounted) setState(() => _selectedIndex = null);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.withOpacity(0.08) : Colors.transparent,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
                bottom: isLast ? BorderSide(color: Colors.grey.shade200) : BorderSide.none,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Row(
              children: [
                Text(option.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class LikertOption {
  final String emoji;
  final String label;
  final int score;

  LikertOption({required this.emoji, required this.label, required this.score});
}
