import 'dart:math';

import 'package:flutter/material.dart';

class CircularShape extends StatelessWidget {
  final double size;
  final Color color;
  final double top;
  final double left;
  final double right;
  final double bottom;

  const CircularShape({
    Key? key,
    required this.size,
    required this.color,
    this.top = 0,
    this.left = 0,
    this.right = 0,
    this.bottom = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.5),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Path path = Path();
    path.moveTo(0, size.height * 0.5);

    // Dalgayı oluşturmak için bir döngü
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(x, size.height * 0.5 + 20 * sin((x / 100) * 2 * pi));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
