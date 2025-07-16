import 'package:buy_buy/models/models.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.imageUrls[0],
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
        ),
      ),
      title: Text(product.name, style: theme.textTheme.titleMedium),
      subtitle: Text(
        'RM ${product.price.toStringAsFixed(2)}',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
