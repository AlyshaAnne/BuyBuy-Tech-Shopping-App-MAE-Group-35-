part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckEvent extends AuthEvent {}

final class AuthSignInEvent extends AuthEvent {
  const AuthSignInEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => super.props..addAll([email, password]);
}

final class AuthLogOutEvent extends AuthEvent {}

final class AuthSignUpEvent extends AuthEvent {
  const AuthSignUpEvent({required this.email, required this.password, required this.phone});

  final String email;
  final String password;
  final String phone;

  @override
  List<Object?> get props => super.props..addAll([email, password, phone]);
}

final class ProfileUpdateEvent extends AuthEvent {
  const ProfileUpdateEvent({required this.updatedProfile});

  final Profile updatedProfile;
}
