import 'package:flutter/material.dart';
import 'package:shop_app/custom/auth_custom_clipper.dart';

class CustomPageAuth extends StatelessWidget {
  const CustomPageAuth({
    Key? key,
    required this.sizeHeight,
    required this.sizeWidth,
    required this.image,
    required this.label,
  }) : super(key: key);

  final double sizeHeight;
  final double sizeWidth;
  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AuthClipper(),
      child: Container(
        height: sizeHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              "assets/icons/illustration.png",
              fit: BoxFit.cover,
              height: sizeHeight,
              width: sizeWidth,
            ),
            Positioned(
              top: 40,
              child: Container(
                height: 70,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
