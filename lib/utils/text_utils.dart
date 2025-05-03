import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  String text;
  Color? color;
  double? size;
  bool? weight;
  TextStyle? style;
  TextUtil({super.key, required this.text, this.color, this.size, this.weight, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: size ?? 16,
        fontWeight: weight == null ? FontWeight.w600 : FontWeight.w700
      )
    );
  }
}