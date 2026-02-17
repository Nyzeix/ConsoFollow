import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final ValueChanged<bool> valueChanged;
  final EdgeInsetsGeometry padding;

  const SettingRow({
    super.key,
    required this.title,
    required this.isEnabled,
    required this.valueChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(title),
        Switch(
          value: isEnabled,
          onChanged: valueChanged,
        )
      ]),
    );
  }
}