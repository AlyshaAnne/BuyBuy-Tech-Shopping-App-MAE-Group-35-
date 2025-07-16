part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

final class CategoryLoadEvent extends CategoryEvent {
  const CategoryLoadEvent({required this.selectedCategory, this.completer});

  final Category selectedCategory;
  final Completer? completer;

  @override
  List<Object?> get props => super.props..addAll([selectedCategory, completer]);
}

final class CategorySwitchEvent extends CategoryEvent {
  const CategorySwitchEvent({required this.category, this.completer});

  final Category category;
  final Completer? completer;

  @override
  List<Object?> get props => super.props..addAll([category, completer]);
}
