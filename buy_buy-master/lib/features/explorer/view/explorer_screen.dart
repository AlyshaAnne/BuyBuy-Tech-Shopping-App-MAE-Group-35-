import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/bloc.dart';
import 'package:buy_buy/features/explorer/explorer.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/router/router.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPage(allCategory);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthState,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              snap: true,
              pinned: true,
              floating: true,
              centerTitle: true,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: GestureDetector(
                onTap: () => {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.room_outlined, color: theme.hintColor, size: 16),
                    Text("Bukit Jalil", style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _onFilterPressed,
                  icon: Icon(Icons.filter_alt_outlined, size: 24),
                  color: theme.hintColor,
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(58),
                child: SearchButton(onTap: _showSearchBottomSheet, controller: _searchController),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16).copyWith(top: 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Category',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: _onViewAllPressed,
                          child: Text('view all', style: TextStyle(color: theme.hintColor)),
                        ),
                      ],
                    ),
                    BlocConsumer<CategoryBloc, CategoryState>(
                      listener: _handleCategoryState,
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is CategoryLoaded) {
                          final categories = [allCategory, ...state.categories];
                          return SizedBox(
                            height: 72,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Category category = categories[index];
                                return CategoryButton(
                                  onTap: () => _onSwitchCategory(category),
                                  category: category,
                                  isSelected: category.id == state.selectedCategory.id,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(width: 16),
                              itemCount: state.categories.length + 1,
                            ),
                          );
                        } else {
                          return Center(child: Text('Error loading categories'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16).copyWith(top: 0),
              sliver: SliverToBoxAdapter(
                child: Text('Our products', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                  } else if (state is ProductLoaded) {
                    final products = state.products;
                    return SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          isFavorite: state.favoriteIds.contains(product.id),
                          product: product,
                          onTap: () => _onProductTap(product),
                          onToggleFavorite: () => _onToggleFavorite(product),
                          onAddToCart: () => _onAddToCart(product),
                        );
                      },
                      itemCount: products.length,
                    );
                  } else if (state is ProductLoadFailed) {
                    return SliverToBoxAdapter(child: Center(child: Text('Error loading products')));
                  } else {
                    return SliverToBoxAdapter(child: Text('No products available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onFilterPressed() async {
    final CategoryBloc categoryBloc = context.read<CategoryBloc>();
    final ProductBloc productBloc = context.read<ProductBloc>();

    final ProductFilter? currentFilter = productBloc.getCurrentFilter();

    final ProductFilter? filter = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 220),
          child: FilterProductsBottomSheet(initialFilter: currentFilter),
        );
      },
    );

    if (filter != null) {
      final selectedCategory = categoryBloc.getSelectedCategory();
      productBloc.add(ProductLoadEvent(categoryId: selectedCategory.id, filter: filter));
    }
  }

  Future<void> _showSearchBottomSheet() async {
    final ProductBloc productBloc = context.read<ProductBloc>();
    final CategoryBloc categoryBloc = context.read<CategoryBloc>();

    final selectedCategory = categoryBloc.getSelectedCategory();

    final query = await showModalBottomSheet<String>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 90),
          child: SearchProductsBottomSheet(controller: _searchController, category: selectedCategory),
        );
      },
    );

    if (query != null) {
      _searchController.text = query;
      productBloc.add(ProductLoadEvent(categoryId: selectedCategory.id, query: query));
    }
  }

  Future<void> _onViewAllPressed() async {
    final categoryBloc = context.read<CategoryBloc>();
    var category = await context.pushRoute<Category>(CategoriesRoute());
    if (category != null) {
      categoryBloc.add(CategoryLoadEvent(selectedCategory: category));
    }
  }

  Future<void> _onSwitchCategory(Category category) async {
    final CategoryBloc categoryBloc = context.read<CategoryBloc>();
    categoryBloc.add(CategorySwitchEvent(category: category));
  }

  Future<void> _loadPage(Category selectedCategory) async {
    final CategoryBloc categoryBloc = context.read<CategoryBloc>();
    categoryBloc.add(CategoryLoadEvent(selectedCategory: selectedCategory));
  }

  Future<void> _onRefresh() async {
    final categoryBloc = context.read<CategoryBloc>();
    final productBloc = context.read<ProductBloc>();

    final Category currentCategory = categoryBloc.getSelectedCategory();
    final ProductFilter? currentFilter = productBloc.getCurrentFilter();

    productBloc.add(ProductLoadEvent(categoryId: currentCategory.id, filter: currentFilter));
  }

  _handleAuthState(BuildContext context, AuthState state) {
    if (state is Authorized || state is Unauthorized) {
      final categoryBloc = context.read<CategoryBloc>();
      final productBloc = context.read<ProductBloc>();

      categoryBloc.add(CategoryLoadEvent(selectedCategory: allCategory));
      productBloc.add(ProductLoadEvent(categoryId: allCategory.id));
    }
  }

  _handleCategoryState(BuildContext context, CategoryState state) {
    if (state is CategoryLoaded) {
      final Category category = state.selectedCategory;
      final ProductBloc productBloc = context.read<ProductBloc>();

      final ProductFilter? currentFilter = productBloc.getCurrentFilter();
      productBloc.add(ProductLoadEvent(categoryId: category.id, filter: currentFilter));
    }
  }

  _onProductTap(Product product) {
    context.pushRoute(ProductDetailRoute(productId: product.id));
  }

  _onToggleFavorite(Product product) async {
    final FavoritesBloc favoritesBloc = context.read<FavoritesBloc>();
    final ProductBloc productBloc = context.read<ProductBloc>();

    final Completer completer = Completer();
    productBloc.add(ToggleFavoriteProductEvent(productId: product.id, completer: completer));
    await completer.future;
    favoritesBloc.add(FavoritesLoadEvent());
  }
  
  _onAddToCart(Product product) async {
    final CartBloc cartBloc = context.read<CartBloc>();
    cartBloc.add(AddToCartEvent(product: product));
  }
}
