import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:vector_math/vector_math_64.dart' show radians;

enum MarkerType { CIRCLE, CROSS, NONE }

class Marker extends StatelessWidget {
  final bool enabled;
  final MarkerType type;
  final Gradient gradient;

  const Marker(
      {Key key, @required this.type, this.gradient, this.enabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: enabled ? 1 : 0),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutQuad,
      builder: (ctx, clipPath, child) => CustomPaint(
        painter: MarkerPainter(
          type: type,
          clipPath: clipPath,
          gradient: gradient,
        ),
      ),
    );
  }
}

class MarkerPainter extends CustomPainter {
  final MarkerType type;
  final double clipPath;
  final Gradient gradient;

  MarkerPainter({this.gradient, this.type, this.clipPath});

  void paintCircle(Canvas canvas, Size size, Paint paint, Path path) {
    path.addArc(Offset.zero & size, 0, radians(360) * clipPath);
    canvas.drawPath(path, paint);
  }

  void paintCross(Canvas canvas, Size size, Paint paint, Path path) {
    var currClip = clipPath * 2;

    path.lineTo(
      size.width * min(currClip, 1.0),
      size.height * min(currClip, 1.0),
    );

    if (currClip > 1.0) {
      currClip--;

      path
        ..relativeMoveTo(-size.width, 0)
        ..relativeLineTo(size.width * currClip, -size.height * currClip);
    }

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    if (gradient != null) {
      paint.shader = gradient.createShader(Offset.zero & size);
    }

    var path = Path();

    switch (type) {
      case MarkerType.CROSS:
        paintCross(canvas, size, paint, path);
        return;

      case MarkerType.CIRCLE:
        paintCircle(canvas, size, paint, path);
        return;

      default:
        return;
    }
  }

  @override
  bool shouldRepaint(MarkerPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.clipPath != clipPath;
}
