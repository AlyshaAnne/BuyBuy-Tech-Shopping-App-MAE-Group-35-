import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/features/explorer/bloc/search/search_bloc.dart';
import 'package:buy_buy/features/explorer/widgets/product_list_tile.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/product/product_repository_interface.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProductsBottomSheet extends StatelessWidget {
  const SearchProductsBottomSheet({super.key, required this.controller, required this.category});

  final TextEditingController controller;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create:
          (context) =>
              SearchBloc(productRepository: context.read<ProductRepositoryInterface>())
                ..add(SearchQueryChanged(category: category, query: controller.text)),
      child: Builder(
        builder: (context) {
          return BaseBottomSheet(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.hintColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              context.read<SearchBloc>().add(SearchQueryChanged(category: category, query: value));
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Start typing product name...',
                              hintStyle: TextStyle(color: theme.hintColor.withValues(alpha: 0.5)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                              border: const OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _onTapSearch(context),
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SearchLoaded) {
                        return ListView.builder(
                          itemCount: state.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = state.filteredProducts[index];
                            return ProductListTile(product: product, onTap: () => _onProductTap(context, product));
                          },
                        );
                      } else if (state is SearchLoadFailed) {
                        return Center(child: Text('Failed to load products'));
                      } else {
                        return const Center(child: Text('No products found'));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onTapSearch(BuildContext context) {
    context.maybePop(controller.text);
  }

  void _onProductTap(BuildContext context, Product product) {
    context.maybePop(product.name);
  }
}
