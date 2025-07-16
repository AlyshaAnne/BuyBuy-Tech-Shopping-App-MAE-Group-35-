import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc({required ProductRepositoryInterface productRepository})
    : _productRepository = productRepository,
      super(BrandInitial()) {
    on<BrandLoadEvent>(_onLoad);
  }

  final ProductRepositoryInterface _productRepository;

  _onLoad(BrandLoadEvent event, Emitter<BrandState> emit) async {
    emit(BrandLoading());
    try {
      final brands = await _productRepository.getBrands();
      emit(BrandLoaded(brands: brands));
    } catch (e) {
      emit(BrandLoadFailure(error: e));
    }
  }
}
