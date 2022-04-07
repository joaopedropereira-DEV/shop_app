import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  AuthButton({
    Key? key,
    required this.label,
    required this.colorButtom,
    required this.colorText,
    required this.isOutlined,
    required this.func,
    this.padding,
  }) : super(key: key);

  final String label;
  final Color colorButtom;
  final Color colorText;
  final bool isOutlined;
  final Function() func;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: padding ?? 0.0),
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: isOutlined
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              )
            : BoxDecoration(
                color: colorButtom,
                borderRadius: BorderRadius.circular(10),
              ),
        child: Text(
          label,
          style: TextStyle(
            color: colorText,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
