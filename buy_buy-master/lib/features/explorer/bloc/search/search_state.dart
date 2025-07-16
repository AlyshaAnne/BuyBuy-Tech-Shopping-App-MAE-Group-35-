part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  const SearchLoaded({required this.filteredProducts});

  final List<Product> filteredProducts;

  @override
  List<Object> get props => super.props..addAll(filteredProducts);
}

final class SearchLoadFailed extends SearchState {
  const SearchLoadFailed({required this.error});

  final Object error;

  @override
  List<Object> get props => super.props..add(error);
}
