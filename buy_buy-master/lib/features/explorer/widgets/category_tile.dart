import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/models/models.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(category.iconData),
      title: Text(category.name),
      onTap: () => context.maybePop<Category>(category),
    );
  }
}
