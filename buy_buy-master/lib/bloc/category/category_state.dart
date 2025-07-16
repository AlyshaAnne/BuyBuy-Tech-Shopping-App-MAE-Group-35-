part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  const CategoryLoaded({required this.categories, required this.selectedCategory});

  final List<Category> categories;
  final Category selectedCategory;

  @override
  List<Object> get props => super.props..add([categories, selectedCategory]);
}

final class CategoryLoadFailed extends CategoryState {
  const CategoryLoadFailed({required this.error});

  final Object error;

  @override
  List<Object> get props => super.props..add(error);
}
