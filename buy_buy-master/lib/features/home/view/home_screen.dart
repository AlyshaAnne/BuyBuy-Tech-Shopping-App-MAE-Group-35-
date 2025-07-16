import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/auth/auth_bloc.dart';
import 'package:buy_buy/bloc/favorites/favorites_bloc.dart';
import 'package:buy_buy/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthCheckEvent());
    context.read<FavoritesBloc>().add(FavoritesLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AutoTabsRouter(
      routes: const [ExplorerRouterRoute(), CartRoute(), FavoritesRoute(), ProfileRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: theme.hintColor,
            unselectedItemColor: theme.scaffoldBackgroundColor,
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) => _openPage(context, index, tabsRouter),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.search_outlined),
                label: 'Explorer',
                backgroundColor: theme.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Cart',
                backgroundColor: theme.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: 'Favorites',
                backgroundColor: theme.primaryColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
                backgroundColor: theme.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPage(BuildContext context, int index, TabsRouter tabsRouter) {
    const protectedRoutes = [1, 2, 3];

    final authBloc = context.read<AuthBloc>();
    final isAuthenticated = authBloc.state is Authorized;

    if (protectedRoutes.contains(index) && !isAuthenticated) {
      context.router.push(const AuthRoute());
      return;
    }

    tabsRouter.setActiveIndex(index);
  }
}
