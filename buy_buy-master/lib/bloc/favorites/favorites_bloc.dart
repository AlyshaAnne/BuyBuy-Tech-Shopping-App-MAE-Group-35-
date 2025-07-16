import 'dart:async';

import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required FavoriteRepositoryInterface favoriteRepository,
    required ProductRepositoryInterface productRepository,
  }) : _favoriteRepository = favoriteRepository,
       _productRepository = productRepository,
       super(FavoritesInitial()) {
    on<FavoritesLoadEvent>(_onLoad);
    on<ToggleFavoriteEvent>(_onToggle);
  }

  final FavoriteRepositoryInterface _favoriteRepository;
  final ProductRepositoryInterface _productRepository;

  _onLoad(FavoritesLoadEvent event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final favoritesId = await _favoriteRepository.getFavoriteIds();
      final allProducts = await _productRepository.getProducts();
      final favorites = allProducts.where((product) => favoritesId.contains(product.id)).toList();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesLoadFailed(error: e));
    }
  }

  _onToggle(ToggleFavoriteEvent event, Emitter<FavoritesState> emit) async {
    try {
      await _favoriteRepository.toggleFavorite(event.product.id);
      add(FavoritesLoadEvent());
    } catch (_) {
      // pass
    } finally {
      event.completer?.complete();
    }
  }
}
