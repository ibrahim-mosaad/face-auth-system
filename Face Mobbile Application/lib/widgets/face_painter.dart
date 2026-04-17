import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  final List faces;

  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var face in faces) {
      final box = face["box"];

      double top = box[0].toDouble();
      double right = box[1].toDouble();
      double bottom = box[2].toDouble();
      double left = box[3].toDouble();

      final rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}