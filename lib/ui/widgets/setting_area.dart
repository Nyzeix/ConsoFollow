import 'package:flutter/material.dart';

class SettingArea extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool folded;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  const SettingArea({
    super.key,
    required this.title,
    required this.children,
    this.color,
    this.folded = true,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor)
        ),
        child: ExpansionTile(
          title: Text(title),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          initiallyExpanded: !folded,
          leading: leading,
          trailing: trailing,
          children: children,
        ),
      ),
    );
  }
}