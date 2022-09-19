import 'package:flutter/material.dart';

class BottomBubble extends CustomPainter {
  double _radius = 5.0;
  double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          0,
          10,
          size.width - _x,
          size.height,
          bottomLeft: Radius.circular(_radius),
          bottomRight: Radius.circular(_radius),
          topRight: Radius.circular(_radius),
          topLeft: Radius.circular(_radius),
        ),
        Paint()
          ..color = Colors.greenAccent
          ..style = PaintingStyle.fill);
    var path = Path();
    path.moveTo(20, 12);
    path.lineTo(30, 0);
    path.lineTo(40, 10);
    canvas.clipPath(path);
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          0,
          0.0,
          size.width,
          size.height,
        ),
        Paint()
          ..color = Colors.greenAccent
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
