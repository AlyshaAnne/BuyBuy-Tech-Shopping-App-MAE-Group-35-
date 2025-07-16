import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required ProductRepositoryInterface productRepository})
    : _productRepository = productRepository,
      super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  final ProductRepositoryInterface _productRepository;

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final products = await _productRepository.getProducts(categoryId: event.category.id, query: query);
      emit(SearchLoaded(filteredProducts: products));
    } catch (e) {
      emit(SearchLoadFailed(error: e));
    }
  }
}
