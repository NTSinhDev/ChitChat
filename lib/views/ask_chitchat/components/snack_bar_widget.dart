import 'package:flutter/material.dart';

class SnackBarWidget {
  static show({required BuildContext context, required String label}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(label: label),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.label,
    this.fontSize = 18,
    this.color,
    this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      // textAlign: TextAlign.justify,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
