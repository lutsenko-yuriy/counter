import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_colors.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({super.key, required this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _fadeOut;
  bool _showChild = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );
    // Fade in the tally counter over 0–40%, hold 40–60%, fade out 60–100%
    _fadeIn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4)),
    );
    _fadeOut = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)),
    );
    _controller.forward().then((_) {
      if (mounted) setState(() => _showChild = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showChild) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = _fadeIn.value * _fadeOut.value;
        return ColoredBox(
          color: AppColors.cream,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: SvgPicture.asset(
          'assets/tally_counter.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
