part of 'brand_bloc.dart';

sealed class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

final class BrandInitial extends BrandState {}

final class BrandLoading extends BrandState {}

final class BrandLoaded extends BrandState {
  const BrandLoaded({required this.brands});

  final List<Brand> brands;

  @override
  List<Object?> get props => super.props..add(brands);
}

final class BrandLoadFailure extends BrandState {
  const BrandLoadFailure({this.error});

  final Object? error;

  @override
  List<Object?> get props => super.props..add(error);
}
