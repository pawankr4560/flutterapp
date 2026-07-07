part of '../pages/plot_directory_page.dart';

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.16)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.18)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.9, size.height * 0.28),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.12),
      Offset(size.width * 0.78, size.height * 0.88),
      thinPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.52, size.height * 0.48),
      10,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _push(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      pageBuilder: (_, animation, _) {
        return FadeTransition(opacity: animation, child: page);
      },
      transitionDuration: const Duration(milliseconds: 220),
    ),
  );
}

