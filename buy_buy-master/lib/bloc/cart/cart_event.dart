part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class CartLoadEvent extends CartEvent {}

final class AddToCartEvent extends CartEvent {
  const AddToCartEvent({required this.product});

  final Product product;

  @override
  List<Object?> get props => super.props..add(product);
}

final class DeleteFromCartEvent extends CartEvent {
  const DeleteFromCartEvent({required this.product});

  final Product product;

  @override
  List<Object?> get props => super.props..add(product);
}
