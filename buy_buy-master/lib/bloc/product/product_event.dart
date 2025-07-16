part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class ProductLoadEvent extends ProductEvent {
  const ProductLoadEvent({this.categoryId, this.query, this.filter});

  final String? categoryId;
  final String? query;
  final ProductFilter? filter;

  @override
  List<Object?> get props => super.props..addAll([categoryId, query, filter]);
}

final class ToggleFavoriteProductEvent extends ProductEvent {
  const ToggleFavoriteProductEvent({required this.productId, this.completer});

  final String productId;
  final Completer? completer;

  @override
  List<Object?> get props => super.props..addAll([productId, completer]);
}
