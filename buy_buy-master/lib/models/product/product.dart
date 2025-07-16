import 'package:json_annotation/json_annotation.dart';

export 'filter.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: 'documentID')
  final String id;

  final String name;
  final String description;

  final String? characteristics;
  final double price;
  final List<String> imageUrls;

  final String categoryId;

  final String brandId;

  final bool isBrandNew;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.characteristics,
    required this.price,
    required this.imageUrls,
    required this.categoryId,
    required this.brandId,
    required this.isBrandNew,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
