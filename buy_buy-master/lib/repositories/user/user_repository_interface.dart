import 'package:buy_buy/models/models.dart';

abstract interface class UserRepositoryInterface {
  Future<Profile?> signIn(String email, String password);

  Future<Profile?> signUp(String email, String password, String phoneNumber);

  Future<void> logout();

  Future<Profile?> getCurrentUser();

  Future<Profile?> updateProfile(Profile updatedProfile);
}
