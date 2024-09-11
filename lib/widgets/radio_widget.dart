import 'package:flutter/material.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({
    required this.groupValue,
    required this.value,
    required this.onChanged,
    required this.color,
    super.key,
  });
  final Color value;
  final Color groupValue;
  final ValueChanged<Color?> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Radio<Color>(
        fillColor: WidgetStateProperty.resolveWith((state) {
          return color;
        }),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged);
  }
}
