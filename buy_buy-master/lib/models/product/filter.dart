import 'package:equatable/equatable.dart';

class ProductFilter extends Equatable {
  final String? brandId;
  final bool? isBrandNew;

  const ProductFilter({this.brandId, this.isBrandNew});

  ProductFilter copyWith({String? brandId, bool? isBrandNew}) {
    return ProductFilter(brandId: brandId ?? this.brandId, isBrandNew: isBrandNew ?? this.isBrandNew);
  }

  @override
  List<Object?> get props => [brandId, isBrandNew];
}
