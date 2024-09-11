import 'package:flutter/material.dart';

class SimpleTextWidget extends StatelessWidget {
  const SimpleTextWidget({required this.text, required this.color, super.key});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
