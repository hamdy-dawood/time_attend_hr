import 'package:flutter/material.dart';
import 'package:time_attend_recognition/features/face_recognize/face_detection_class.dart';

class FacePainter extends CustomPainter {
  dynamic faces;

  FacePainter({required this.faces});

  @override
  void paint(Canvas canvas, Size size) {
    final double livenessThreshold = getLivenessThreshold();

    if (faces != null) {
      var paint = Paint();
      paint.color = const Color.fromARGB(0xff, 0xff, 0, 0);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;

      for (var face in faces) {
        double xScale = face['frameWidth'] / size.width;
        double yScale = face['frameHeight'] / size.height;

        String title = "";
        Color color = const Color.fromARGB(0xff, 0xff, 0, 0);
        if (face['liveness'] < livenessThreshold) {
          color = const Color.fromARGB(0xff, 0xff, 0, 0);
          title = "Spoof${face['liveness']}";
        } else {
          color = const Color.fromARGB(0xff, 0, 0xff, 0);
          title = "Real ${face['liveness']}";
        }

        TextSpan span = TextSpan(style: TextStyle(color: color, fontSize: 20), text: title);
        TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(face['x1'] / xScale, face['y1'] / yScale - 30));

        paint.color = color;
        canvas.drawRect(Offset(face['x1'] / xScale, face['y1'] / yScale) & Size((face['x2'] - face['x1']) / xScale, (face['y2'] - face['y1']) / yScale), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
