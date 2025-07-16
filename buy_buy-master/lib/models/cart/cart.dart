import 'package:buy_buy/models/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable()
class CartItem {
  CartItem({required this.productId, required this.quantity});

  final String productId;
  final int quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

class CartItemDetail {
  final Product product;

  late final int quantity;

  CartItemDetail({required this.product, required this.quantity});

  CartItemDetail.fromCartItem({required CartItem item, required this.product}) : quantity = item.quantity;

  CartItem toCartItem() => CartItem(productId: product.id, quantity: quantity);

  CartItemDetail copyWith({Product? product, int? quantity}) {
    return CartItemDetail(product: product ?? this.product, quantity: quantity ?? this.quantity);
  }
}
