part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({required this.favorites});

  final List<Product> favorites;

  @override
  List<Object?> get props => super.props..add(favorites);
}

final class FavoritesLoadFailed extends FavoritesState {
  const FavoritesLoadFailed({this.error});

  final Object? error;

  @override
  List<Object?> get props => super.props..add(error);
}
