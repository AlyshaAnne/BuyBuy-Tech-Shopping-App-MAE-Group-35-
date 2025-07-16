import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/user/user_repository_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required UserRepositoryInterface userRepository}) : _userRepository = userRepository, super(AuthInitial()) {
    on<AuthCheckEvent>(_onAuthCheckEvent);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLogOutEvent>(_onLogout);
    on<ProfileUpdateEvent>(_onUpdateProfile);
  }

  final UserRepositoryInterface _userRepository;

  void _onAuthCheckEvent(AuthCheckEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final Profile? profile = await _userRepository.getCurrentUser();
      if (profile != null) {
        emit(Authorized(profile: profile, initial: true));
      } else {
        emit(Unauthorized());
      }
    } catch (e) {
      emit(Unauthorized(error: e));
    }
  }

  void _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final Profile? profile = await _userRepository.signIn(event.email, event.password);
      if (profile != null) {
        emit(Authorized(profile: profile));
      } else {
        emit(const Unauthorized(error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(Unauthorized(error: e));
    }
  }

  void _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final Profile? profile = await _userRepository.signUp(event.email, event.password, event.phone);
      if (profile != null) {
        emit(Authorized(profile: profile));
      } else {
        emit(const Unauthorized(error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(Unauthorized(error: e));
    }
  }

  void _onLogout(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _userRepository.logout();
      emit(Unauthorized());
    } catch (e) {
      emit(Unauthorized(error: e));
    }
  }

  void _onUpdateProfile(ProfileUpdateEvent event, Emitter<AuthState> emit) async {
    emit(ProfileUpdating());
    try {
      final profile = await _userRepository.updateProfile(event.updatedProfile);
      if (profile == null) {
        throw Exception('Updating profile unknown error');
      }
      emit(Authorized(profile: profile));
    } catch (e) {
      emit(ProfileUpdateFailed(error: e));
      emit(state);
    }
  }
}
