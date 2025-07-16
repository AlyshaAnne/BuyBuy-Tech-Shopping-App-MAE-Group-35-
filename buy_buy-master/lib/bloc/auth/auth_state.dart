part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authorized extends AuthState {
  const Authorized({required this.profile, this.initial = false});

  final Profile profile;
  final bool initial;

  @override
  List<Object?> get props => super.props..addAll([profile, initial]);
}

final class Unauthorized extends AuthState {
  const Unauthorized({this.error});

  final Object? error;

  @override
  List<Object?> get props => super.props..add(error);
}

final class ProfileUpdating extends AuthState {}

final class ProfileUpdateFailed extends AuthState {
  const ProfileUpdateFailed({this.error});

  final Object? error;

  @override
  List<Object?> get props => super.props..add(error);
}
