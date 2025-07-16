part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

final class ProductDetailLoadEvent extends ProductDetailEvent {
  const ProductDetailLoadEvent({required this.productId});

  final String productId;

  @override
  List<Object?> get props => super.props..add(productId);
}
