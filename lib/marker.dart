import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:vector_math/vector_math_64.dart' show radians;

enum MarkerType { CIRCLE, CROSS, NONE }

class Marker extends StatelessWidget {
  final bool enabled;
  final MarkerType type;

  const Marker({Key key, @required this.type, this.enabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MarkerType.CROSS
        ? MarkerCross(enabled: enabled)
        : MarkerCircle(enabled: enabled);
  }
}

class MarkerCircle extends StatelessWidget {
  final bool enabled;

  const MarkerCircle({Key key, this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: enabled ? 1 : 0),
      duration: Duration(seconds: 1),
      builder: (ctx, clipPath, child) => CustomPaint(
        painter: CirclePainter(clipPath: clipPath),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double clipPath;

  CirclePainter({this.clipPath = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    var path = Path()..addArc(Offset.zero & size, 0, radians(360) * clipPath);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.clipPath != clipPath;
  }
}

class MarkerCross extends StatelessWidget {
  final bool enabled;

  const MarkerCross({Key key, this.enabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: enabled ? 1 : 0),
      duration: Duration(seconds: 1),
      builder: (ctx, clipPath, child) => CustomPaint(
        painter: CrossPainter(clipPath: clipPath),
      ),
    );
  }
}

class CrossPainter extends CustomPainter {
  final double clipPath;

  CrossPainter({this.clipPath});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    var currClip = clipPath * 2;

    path
      ..lineTo(
          size.width * min(currClip, 1.0), size.height * min(currClip, 1.0));

    if (currClip > 1.0) {
      currClip -= 1;

      path
        ..relativeMoveTo(-size.width, 0)
        ..relativeLineTo(size.width * currClip, -size.height * currClip);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
