import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/bloc.dart';
import 'package:buy_buy/features/product/product.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, @PathParam('id') required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    final ProductDetailBloc productDetailBloc = context.read<ProductDetailBloc>();
    productDetailBloc.add(ProductDetailLoadEvent(productId: widget.productId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailInitial || state is ProductDetailLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is ProductDetailLoadFailed) {
          return const Scaffold(body: Center(child: Text('Failed to load product details')));
        }

        final product = (state as ProductDetailLoaded).product;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(pinned: true, snap: true, floating: true, centerTitle: true, title: Text('Product Details')),
              SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.all(16), child: ImageCarousel(images: product.imageUrls)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.name, style: theme.textTheme.titleLarge),
                          BaseTag(
                            child: Text(
                              (product.isBrandNew) ? 'BN' : 'SH',
                              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, favState) {
                              final isFavorite =
                                  favState is FavoritesLoaded && favState.favorites.any((fav) => fav.id == product.id);
                              return FavoriteButton(
                                isFavorite: isFavorite,
                                onToggleFavorite: () => _onToggleFavorite(product),
                              );
                            },
                          ),
                        ],
                      ),

                      if (product.characteristics != null) ...[
                        Text(
                          product.characteristics!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                        ),
                      ],

                      Text(product.description, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 48),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: theme.hintColor),
                onPressed: _onAddToCart,
                child: const Text('Add to Cart'),
              ),
            ),
          ),
        );
      },
    );
  }

  _onToggleFavorite(Product product) async {
    final FavoritesBloc favoritesBloc = context.read<FavoritesBloc>();
    final ProductBloc productBloc = context.read<ProductBloc>();
    final ProductDetailBloc productDetailBloc = context.read<ProductDetailBloc>();

    final Completer completer = Completer();
    productBloc.add(ToggleFavoriteProductEvent(productId: product.id, completer: completer));
    await completer.future;
    favoritesBloc.add(FavoritesLoadEvent());
    productDetailBloc.add(ProductDetailLoadEvent(productId: product.id));
  }

  _onAddToCart() {
    final CartBloc cartBloc = context.read<CartBloc>();
    final ProductDetailBloc productDetailBloc = context.read<ProductDetailBloc>();

    if (productDetailBloc.state is ProductDetailLoaded) {
      final product = (productDetailBloc.state as ProductDetailLoaded).product;
      cartBloc.add(AddToCartEvent(product: product));
    }
  }
}
