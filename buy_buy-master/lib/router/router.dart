import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/features/features.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      children: [
        AutoRoute(
          page: ExplorerRouterRoute.page,
          path: 'explorer',
          children: [
            AutoRoute(page: ExplorerRoute.page, path: ''),
            AutoRoute(page: CategoriesRoute.page, path: 'categories'),
          ],
        ),
        AutoRoute(page: CartRoute.page),
        AutoRoute(page: FavoritesRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: AuthRoute.page, path: '/auth'),
    AutoRoute(page: ProductDetailRoute.page, path: '/product/:id'),
  ];
}
