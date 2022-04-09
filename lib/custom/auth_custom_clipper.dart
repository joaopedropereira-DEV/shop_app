import 'package:flutter/material.dart';

class AuthClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0, size.height * 0.9);

    path.cubicTo(size.width / 4, 3 * (size.height * 0.4), 3 * (size.width / 4),
        size.height * 0.6, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
