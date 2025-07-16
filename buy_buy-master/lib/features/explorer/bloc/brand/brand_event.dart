part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

final class BrandLoadEvent extends BrandEvent {}
