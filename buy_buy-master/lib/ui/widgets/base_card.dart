import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.width,
    this.height,
    required this.child,
  });

  final EdgeInsets padding;
  final double borderRadius;

  final double? width;
  final double? height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      elevation: 1,
      child: Container(padding: padding, width: width, height: height, child: child),
    );
  }
}
