import 'package:flutter/material.dart';

class BackgroundOfCircularIndicatorPainter extends CustomPainter {
  final Color circleBackgroundColor;
  BackgroundOfCircularIndicatorPainter(this.circleBackgroundColor);
  @override
  void paint(Canvas canvas, Size size) {
    // Get the center of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    final Paint brushForCircle = Paint()
      ..style = PaintingStyle.stroke
      ..color = circleBackgroundColor
      ..strokeWidth = 30;

    canvas.drawCircle(
      center,
      size.width / 2.5,
      brushForCircle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
