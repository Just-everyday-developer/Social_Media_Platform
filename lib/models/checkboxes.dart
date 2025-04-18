import 'package:flutter/material.dart';

class EmptyCheckbox extends StatelessWidget {
  const EmptyCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_box_outline_blank, color: Colors.white,);
  }
}

class FilledCheckbox extends StatelessWidget {
  const FilledCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_box, color: Colors.white);
  }
}