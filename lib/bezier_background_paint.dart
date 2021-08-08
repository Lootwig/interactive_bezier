import 'dart:ui';

import 'package:flutter/material.dart';

class BezierBackgroundPaint extends CustomPainter {
  final start;
  final firstStop;
  final secondStop;
  final lastStop;
  final firstControl;
  final secondControl;
  final lastControl;
  final Paint _paint;
  final Color color;
  final bool interactive;
  late Offset startControlAfter;
  late Offset firstControlAfter;
  late Offset secondControlAfter;

  BezierBackgroundPaint(
      this.start,
      this.firstStop,
      this.secondStop,
      this.lastStop,
      this.firstControl,
      this.secondControl,
      this.lastControl,
      this.color,
      this.interactive,
      ) : _paint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    startControlAfter = Offset(width * .2, start.dy - height * .1);
    firstControlAfter = firstStop + _continuousControl(firstStop, firstControl);
    secondControlAfter =
        secondStop + _continuousControl(secondStop, secondControl);

    final path = Path()
      ..lineTo(start.dx, start.dy)
      ..cubicTo(
        startControlAfter.dx,
        startControlAfter.dy,
        firstControl.dx,
        firstControl.dy,
        firstStop.dx,
        firstStop.dy,
      )
      ..cubicTo(
        firstControlAfter.dx,
        firstControlAfter.dy,
        secondControl.dx,
        secondControl.dy,
        secondStop.dx,
        secondStop.dy,
      )
      ..cubicTo(
        secondControlAfter.dx,
        secondControlAfter.dy,
        lastControl.dx,
        lastControl.dy,
        lastStop.dx,
        lastStop.dy,
      )
      ..lineTo(width, 0);
    canvas.drawPath(path, _paint);
    if (interactive) {
      _drawHandles(canvas);
    }
  }

  void _drawHandles(Canvas canvas) {
    [
      [firstStop, firstControl],
      [secondStop, secondControl],
      [lastStop, lastControl],
    ].forEach((pair) =>
        canvas.drawLine(pair[0], pair[1], Paint()..color = Colors.red));

    canvas.drawPoints(
        PointMode.points,
        [start, firstStop, secondStop, lastStop],
        Paint()
          ..color = Colors.green
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.butt);
    canvas.drawPoints(
        PointMode.points,
        [
          firstControl,
          secondControl,
          lastControl,
        ],
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.butt);
  }

  Offset _continuousControl(Offset origin, Offset previousControl) {
    final offset = origin - previousControl;
    return Offset.fromDirection(offset.direction, offset.distance);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
