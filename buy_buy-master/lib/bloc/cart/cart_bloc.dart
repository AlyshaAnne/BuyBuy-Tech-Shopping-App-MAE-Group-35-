import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required CartRepositoryInterface cartRepository, required ProductRepositoryInterface productRepository})
    : _cartRepository = cartRepository,
      _productRepository = productRepository,
      super(CartInitial()) {
    on<CartLoadEvent>(_onLoad);
    on<AddToCartEvent>(_onAddToCart);
    on<DeleteFromCartEvent>(_onRemoveFromCart);
  }

  final CartRepositoryInterface _cartRepository;
  final ProductRepositoryInterface _productRepository;

  _onLoad(CartLoadEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final List<CartItem> rawCart = await _cartRepository.getCartItems();
      final List<Product> products = await _productRepository.getProducts();
      final List<CartItemDetail> cartItems =
          rawCart.map((CartItem cartItem) {
            final product = products.firstWhere((product) => product.id == cartItem.productId);
            return CartItemDetail(product: product, quantity: cartItem.quantity);
          }).toList();
      emit(CartLoaded(cartItems: cartItems));
    } catch (e) {
      emit(CartLoadFailed(error: e));
    }
  }

  _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final prev = state;
    if (prev is! CartLoaded) return;

    final updated = List<CartItemDetail>.from(prev.cartItems);

    final idx = updated.indexWhere((it) => it.product.id == event.product.id);
    if (idx != -1) {
      updated[idx] = updated[idx].copyWith(quantity: updated[idx].quantity + 1);
    } else {
      updated.add(CartItemDetail(product: event.product, quantity: 1));
    }

    await _cartRepository.updateCart(cartItems: updated.map((it) => it.toCartItem()).toList());

    emit(CartLoaded(cartItems: updated));
  }

  _onRemoveFromCart(DeleteFromCartEvent event, Emitter<CartState> emit) async {
    final prev = state;
    if (prev is! CartLoaded) return;

    final updated = List<CartItemDetail>.from(prev.cartItems);

    final idx = updated.indexWhere((it) => it.product.id == event.product.id);
    if (idx != -1) {
      final item = updated[idx];
      if (item.quantity > 1) {
        updated[idx] = item.copyWith(quantity: item.quantity - 1);
      } else {
        updated.removeAt(idx);
      }
    }

    final toUpdate = updated.map((it) => it.toCartItem()).toList();
    await _cartRepository.updateCart(cartItems: toUpdate);

    emit(CartLoaded(cartItems: updated));
  }
}
