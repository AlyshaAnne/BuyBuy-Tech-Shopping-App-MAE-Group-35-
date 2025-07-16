import 'dart:async';

import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/category/category_repository_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required CategoryRepositoryInterface categoryRepository})
    : _categoryRepository = categoryRepository,
      super(CategoryInitial()) {
    on<CategoryLoadEvent>(_onLoad);
    on<CategorySwitchEvent>(_onSwitch);
  }

  final CategoryRepositoryInterface _categoryRepository;

  _onLoad(CategoryLoadEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getAllCategories();
      emit(CategoryLoaded(categories: categories, selectedCategory: event.selectedCategory));
    } catch (e) {
      emit(CategoryLoadFailed(error: e));
    } finally {
      event.completer?.complete();
    }
  }

  _onSwitch(CategorySwitchEvent event, Emitter<CategoryState> emit) async {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(CategoryLoaded(categories: currentState.categories, selectedCategory: event.category));
    }
    event.completer?.complete();
  }

  Category getSelectedCategory() {
    if (state is CategoryLoaded) {
      return (state as CategoryLoaded).selectedCategory;
    }
    return allCategory;
  }
}
