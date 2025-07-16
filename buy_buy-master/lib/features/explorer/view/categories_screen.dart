import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/category/category_bloc.dart';
import 'package:buy_buy/features/explorer/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                centerTitle: true,
                title: Text(
                  'Select Category',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (state is CategoryLoading) ...[
                const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator())),
              ] else if (state is CategoryLoaded) ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) => CategoryTile(category: state.categories[index]),
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemCount: state.categories.length,
                  ),
                ),
              ] else ...[
                const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('Error loading categories'))),
              ],
            ],
          );
        },
      ),
    );
  }
}
