part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  const ProductLoaded({required this.products, required this.favoriteIds, this.filter});

  final List<Product> products;

  final List<String> favoriteIds;

  final ProductFilter? filter;

  @override
  List<Object?> get props => super.props..addAll([products, favoriteIds, filter]);

  ProductLoaded copyWith({List<Product>? products, List<String>? favoriteIds, ProductFilter? filter}) {
    return ProductLoaded(
      products: products ?? this.products,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      filter: filter ?? this.filter,
    );
  }
}

final class ProductLoadFailed extends ProductState {
  const ProductLoadFailed({required this.error});

  final Object? error;

  @override
  List<Object?> get props => super.props..add(error);
}
