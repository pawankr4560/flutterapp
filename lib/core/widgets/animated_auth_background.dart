import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';

class AnimatedAuthBackground extends StatefulWidget {
  const AnimatedAuthBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedAuthBackground> createState() => _AnimatedAuthBackgroundState();
}

class _AnimatedAuthBackgroundState extends State<AnimatedAuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset _targetParallax = Offset.zero;
  Offset _currentParallax = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWide = mediaQuery.size.width >= 900;
    final reduceMotion = mediaQuery.disableAnimations;

    if (reduceMotion && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduceMotion && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    final background = IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final progress = reduceMotion ? 0.5 : _controller.value;
            final parallax = reduceMotion
                ? Offset.zero
                : Offset.lerp(_currentParallax, _targetParallax, 0.08)!;
            _currentParallax = parallax;

            return Stack(
              fit: StackFit.expand,
              children: [
                _DriftingCircle(
                  progress: progress,
                  parallax: parallax,
                  alignment: const Alignment(-1.28, -1.08),
                  sizeFactor: 0.58,
                  color: AppColors.primary.withValues(alpha: 0.14),
                  amplitude: const Offset(16, 12),
                  phase: 0,
                  frequency: 1,
                ),
                _DriftingCircle(
                  progress: progress,
                  parallax: parallax,
                  alignment: const Alignment(0.82, -0.68),
                  sizeFactor: 0.42,
                  color: AppColors.secondary.withValues(alpha: 0.13),
                  amplitude: const Offset(12, 18),
                  phase: 0.24,
                  frequency: 1.35,
                ),
                _DriftingCircle(
                  progress: progress,
                  parallax: parallax,
                  alignment: const Alignment(1.18, 0.16),
                  sizeFactor: 0.36,
                  color: AppColors.primary.withValues(alpha: 0.10),
                  amplitude: const Offset(14, 10),
                  phase: 0.58,
                  frequency: 1.18,
                ),
                _DriftingCircle(
                  progress: progress,
                  parallax: parallax,
                  alignment: const Alignment(0.88, 1.18),
                  sizeFactor: 0.56,
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  amplitude: const Offset(18, 14),
                  phase: 0.82,
                  frequency: 0.9,
                ),
              ],
            );
          },
        ),
      ),
    );

    final content = Stack(
      fit: StackFit.expand,
      children: [background, widget.child],
    );

    if (!isWide || reduceMotion) {
      return content;
    }

    return MouseRegion(
      onHover: (event) =>
          _updatePointerParallax(event.localPosition, mediaQuery.size),
      onExit: (_) => setState(() => _targetParallax = Offset.zero),
      child: content,
    );
  }

  void _updatePointerParallax(Offset position, Size size) {
    final normalized = Offset(
      (position.dx / size.width - 0.5) * 2,
      (position.dy / size.height - 0.5) * 2,
    );
    final nextTarget = Offset(
      normalized.dx.clamp(-1.0, 1.0) * 18,
      normalized.dy.clamp(-1.0, 1.0) * 18,
    );

    if ((nextTarget - _targetParallax).distance < 0.5) {
      return;
    }

    setState(() => _targetParallax = nextTarget);
  }
}

class _DriftingCircle extends StatelessWidget {
  const _DriftingCircle({
    required this.progress,
    required this.parallax,
    required this.alignment,
    required this.sizeFactor,
    required this.color,
    required this.amplitude,
    required this.phase,
    required this.frequency,
  });

  final double progress;
  final Offset parallax;
  final Alignment alignment;
  final double sizeFactor;
  final Color color;
  final Offset amplitude;
  final double phase;
  final double frequency;

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final size = math.max(shortestSide * sizeFactor, 150.0);
    final angle = (progress * frequency + phase) * math.pi * 2;
    final idleOffset = Offset(
      math.cos(angle) * amplitude.dx,
      math.sin(angle) * amplitude.dy,
    );

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: idleOffset + parallax,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
