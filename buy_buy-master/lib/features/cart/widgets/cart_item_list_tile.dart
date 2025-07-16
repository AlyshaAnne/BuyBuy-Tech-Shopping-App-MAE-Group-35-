import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';

class CartItemListTile extends StatelessWidget {
  final CartItemDetail cartItem;

  final VoidCallback? onTap;

  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const CartItemListTile({super.key, required this.cartItem, required this.onTap, this.onAdd, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    final theme = Theme.of(context);
    final totalPrice = product.price * cartItem.quantity;

    return GestureDetector(
      onTap: onTap,
      child: BaseCard(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrls[0],
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 64, color: theme.hintColor),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: theme.textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('RM ${product.price.toStringAsFixed(2)} each', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          'Total: RM ${totalPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (onRemove != null)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: onRemove,
                            splashRadius: 20,
                            color: theme.primaryColor,
                          ),
                        Text('${cartItem.quantity}', style: theme.textTheme.bodyLarge),
                        if (onAdd != null)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: onAdd,
                            splashRadius: 20,
                            color: theme.primaryColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
