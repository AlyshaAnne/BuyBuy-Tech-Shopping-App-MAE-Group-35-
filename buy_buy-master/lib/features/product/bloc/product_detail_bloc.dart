import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required ProductRepositoryInterface productRepository})
    : _productRepository = productRepository,
      super(ProductDetailInitial()) {
    on<ProductDetailLoadEvent>(_onLoad);
  }

  final ProductRepositoryInterface _productRepository;

  _onLoad(ProductDetailLoadEvent event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoading());
    try {
      final product = await _productRepository.getProductById(event.productId);
      if (product == null) {
        emit(ProductDetailLoadFailed(error: 'Product not found'));
        return;
      }
      emit(ProductDetailLoaded(product: product));
    } catch (e) {
      emit(ProductDetailLoadFailed(error: e));
    }
  }
}
