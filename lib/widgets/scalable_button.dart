import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScalableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  final EdgeInsets padding;
  final double borderRadius;

  const ScalableButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius = 16,
  });

  @override
  State<ScalableButton> createState() => _ScalableButtonState();
}

class _ScalableButtonState extends State<ScalableButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? Theme.of(context).primaryColor).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
