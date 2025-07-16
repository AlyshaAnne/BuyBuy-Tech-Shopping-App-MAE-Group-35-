import 'package:buy_buy/models/models.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  const CategoryButton({super.key, required this.category, required this.isSelected, required this.onTap});

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(color: theme.primaryColor.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
            ],
            shape: CircleBorder(),
            color: widget.isSelected ? theme.hintColor : theme.indicatorColor,
          ),
          child: IconButton(
            onPressed: widget.onTap,
            icon: Icon(
              widget.category.iconData,
              color: widget.isSelected ? theme.scaffoldBackgroundColor : theme.primaryColor,
            ),
          ),
        ),
        Text(widget.category.name, style: TextStyle(color: widget.isSelected ? theme.hintColor : theme.primaryColor)),
      ],
    );
  }
}
