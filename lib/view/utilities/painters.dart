import 'package:flutter/material.dart';
import 'package:matager/view/utilities/theme.dart';

class BackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = CustomColors.whiteBG;
    canvas.drawPaint(paint);
    Path path1 = Path();
    path1.lineTo(0, 0);
    path1.lineTo(0, size.height * 0.2);
    path1.quadraticBezierTo(
        size.width * .4, size.height * .3, size.width*0.6, 0);

    path1.lineTo(0, 0);
    paint.color = CustomColors.darkRed;
    path1.close();
    canvas.drawPath(path1, paint);
    Path path2 = Path();
    path2.lineTo(size.width, size.height * 0.75);
    path2.quadraticBezierTo(
        size.width * 0.6, size.height * .8, size.width * 0.5, size.height);
    path2.lineTo(size.width, size.height);

    path2.lineTo(size.width, size.height * 0.75);
    paint.color = CustomColors.darkRed;
    path2.close();
    canvas.drawPath(path2, paint);
    Path path3 = Path();
    path3.lineTo(0, size.height * 0.55);
    path3.quadraticBezierTo(
        size.width * 0.4, size.height * .65, 0, size.height * 0.8);

    path3.lineTo(0, size.height * 0.55);
    paint.color = CustomColors.darkRed;
    path3.close();
    canvas.drawPath(path3, paint);
    Path path4 = Path();
    path4.lineTo(size.width,size.height * 0.2);
    path4.lineTo(size.width, size.height * 0.12);
    path4.quadraticBezierTo(
        size.width * .5, size.height * .3, size.width, size.height * 0.4);

    path4.lineTo(size.width,size.height * 0.2);
    paint.color = CustomColors.darkRed;
    path4.close();
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
