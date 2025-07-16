import 'package:flutter/material.dart';

class BaseTag extends StatelessWidget {
  const BaseTag({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: theme.highlightColor, borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }
}
