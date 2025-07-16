import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/bloc/auth/auth_bloc.dart';
import 'package:buy_buy/bloc/cart/cart_bloc.dart';
import 'package:buy_buy/features/cart/widgets/cart_item_list_tile.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthState,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final total =
              state is CartLoaded
                  ? state.cartItems.fold<double>(0, (sum, it) => sum + it.product.price * it.quantity)
                  : 0.0;

          return Scaffold(
            body: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(pinned: true, floating: true, snap: true, centerTitle: true, title: const Text('My Cart')),

                if (state is CartLoading) ...[
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                ] else if (state is CartLoaded) ...[
                  if (state.cartItems.isEmpty)
                    const SliverFillRemaining(child: Center(child: Text('Your cart is empty')))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((ctx, i) {
                          final detail = state.cartItems[i];
                          return CartItemListTile(
                            cartItem: detail,
                            onTap: () => _onProductTap(detail.product),
                            onAdd: () => _onAddToCart(detail.product),
                            onRemove: () => _onRemoveFromCart(detail.product),
                          );
                        }, childCount: state.cartItems.length),
                      ),
                    ),
                ] else ...[
                  SliverFillRemaining(child: Center(child: Text('Unable to load cart'))),
                ],
              ],
            ),

            bottomNavigationBar:
                state is CartLoaded && state.cartItems.isNotEmpty
                    ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total: RM ${total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.hintColor,
                            ),
                            onPressed: _onCheckout,
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    )
                    : null,
          );
        },
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is Authorized) {
      context.read<CartBloc>().add(CartLoadEvent());
    }
  }

  void _onProductTap(Product product) {
    context.router.push(ProductDetailRoute(productId: product.id));
  }

  void _onAddToCart(Product product) {
    context.read<CartBloc>().add(AddToCartEvent(product: product));
  }

  void _onRemoveFromCart(Product product) {
    context.read<CartBloc>().add(DeleteFromCartEvent(product: product));
  }

  void _onCheckout() {
    // Handle checkout
  }
}
