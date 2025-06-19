import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final bool? weight;
  final TextStyle? style;
  final VoidCallback? onTap; // Add callback

  const TextUtil({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.weight,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the callback
      child: Text(
        text,
        style: style ??
            TextStyle(
              color: color ?? Colors.white,
              fontSize: size ?? 16,
              fontWeight: weight == null ? FontWeight.w600 : FontWeight.w700,
            ),
      ),
    );
  }
}