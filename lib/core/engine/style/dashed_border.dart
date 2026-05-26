import 'dart:math' as math;
import 'dart:ui';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:flutter/material.dart';

class QDriveDashedBorder extends StatelessWidget {
  final Widget child;
  final List<String> classes;
  final double dashWidth;
  final double dashGap;

  const QDriveDashedBorder({
    super.key,
    required this.child,
    required this.classes,
    this.dashWidth = 7,
    this.dashGap = 6,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = ElementSettings.radius(classes);

    return CustomPaint(
      foregroundPainter: _QDriveDashedBorderPainter(
        color: ElementSettings.borderColor(context, classes),
        strokeWidth: ElementSettings.borderWidth(classes),
        borderRadius: borderRadius,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: ClipRRect(borderRadius: borderRadius, child: child),
    );
  }
}

class _QDriveDashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final BorderRadius borderRadius;
  final double dashWidth;
  final double dashGap;

  const _QDriveDashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth <= 0) return;

    final rect = Offset.zero & size;

    final rrect = borderRadius.toRRect(rect.deflate(strokeWidth / 2));

    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final next = math.min(distance + dashWidth, metric.length);

        canvas.drawPath(metric.extractPath(distance, next), paint);

        distance = next + dashGap;
      }
    }
  }

  
  @override
  bool shouldRepaint(covariant _QDriveDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
