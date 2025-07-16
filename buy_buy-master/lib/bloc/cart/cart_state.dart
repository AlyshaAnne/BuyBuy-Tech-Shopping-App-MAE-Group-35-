part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  const CartLoaded({required this.cartItems});

  final List<CartItemDetail> cartItems;

  @override
  List<Object?> get props => super.props..add(cartItems);
}

final class CartLoadFailed extends CartState {
  const CartLoadFailed({required this.error});

  final Object? error;

  @override
  List<Object?> get props => super.props..add(error);
}
