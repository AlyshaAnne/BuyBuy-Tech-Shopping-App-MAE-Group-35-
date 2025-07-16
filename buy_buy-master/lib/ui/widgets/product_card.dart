import 'package:buy_buy/features/auth/auth.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:buy_buy/ui/widgets/base_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
    required this.onToggleFavorite,
    this.isFavorite = false,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: theme.shadowColor.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.imageUrls[0],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
              ),
            ),

            if (!product.isBrandNew)
              Positioned(
                top: 8,
                left: 8,
                child: BaseTag(
                  child: Text('SH', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
              ),

            if (onAddToCart != null)
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is! Authorized) {
                    return const SizedBox.shrink();
                  }

                  return Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
                      color: theme.primaryColor,
                      onPressed: onAddToCart,
                      tooltip: 'Add to cart',
                    ),
                  );
                },
              ),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is! Authorized) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(isFavorite: isFavorite, onToggleFavorite: onToggleFavorite, size: 16),
                );
              },
            ),
            Positioned(
              bottom: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(product.name, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (product.characteristics?.isNotEmpty == true)
                      Text(
                        product.characteristics!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
