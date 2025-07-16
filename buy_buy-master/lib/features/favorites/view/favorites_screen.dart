import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/auth/auth_bloc.dart';
import 'package:buy_buy/bloc/category/category_bloc.dart';
import 'package:buy_buy/bloc/favorites/favorites_bloc.dart';
import 'package:buy_buy/bloc/product/product_bloc.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/router/router.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthState,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(snap: true, pinned: true, floating: true, centerTitle: true, title: const Text('Favorites')),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                  } else if (state is FavoritesLoaded) {
                    final favorites = state.favorites;
                    if (favorites.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No favorites found. Try adding some!')),
                      );
                    }
                    return SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final product = favorites[index];
                        return ProductCard(
                          isFavorite: true,
                          product: product,
                          onTap: () => _onProductTap(product),
                          onToggleFavorite: () => _onRemoveFavorite(product),
                        );
                      },
                    );
                  } else {
                    return const SliverToBoxAdapter(child: Center(child: Text('No favorites found')));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onProductTap(Product product) {
    context.pushRoute(ProductDetailRoute(productId: product.id));
  }

  void _onRemoveFavorite(Product product) async {
    final favoritesBloc = context.read<FavoritesBloc>();
    final productBloc = context.read<ProductBloc>();
    final categoryBloc = context.read<CategoryBloc>();

    final selectedCategory =
        categoryBloc.state is CategoryLoaded ? (categoryBloc.state as CategoryLoaded).selectedCategory : allCategory;

    final completer = Completer();
    favoritesBloc.add(ToggleFavoriteEvent(product: product, completer: completer));
    await completer.future;

    productBloc.add(ProductLoadEvent(categoryId: selectedCategory.id));
  }

  _handleAuthState(BuildContext context, state) {
    if (state is Authorized) {
      context.read<FavoritesBloc>().add(FavoritesLoadEvent());
    }
  }

  Future<void> _onRefresh() async {
    final favoritesBloc = context.read<FavoritesBloc>();
    final authBloc = context.read<AuthBloc>();

    if (authBloc.state is Authorized) {
      favoritesBloc.add(FavoritesLoadEvent());
    }
  }
}
