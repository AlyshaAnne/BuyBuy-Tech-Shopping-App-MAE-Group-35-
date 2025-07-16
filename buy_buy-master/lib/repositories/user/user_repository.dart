import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/repositories/user/user_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository implements UserRepositoryInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }

  @override
  Future<Profile?> signIn(String email, String password) async {
    UserCredential credentials = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    User? user = credentials.user;
    if (user == null) {
      return null;
    }

    try {
      DocumentSnapshot userDoc = await _users.doc(user.uid).get();
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      return Profile.fromJson({...data, 'documentID': user.uid, 'email': user.email});
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Profile?> signUp(String email, String password, String phoneNumber) async {
    UserCredential credentials = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    User? user = credentials.user;

    if (user == null) {
      return null;
    }

    Profile profile = Profile(
      id: user.uid,
      email: email,
      phone: phoneNumber,
      name: 'Unknown User',
      gender: Gender.unknown,
      dateOfBirth: DateTime.now(),
      avatarUrl: '',
    );

    Map<String, dynamic> jsonProfile = profile.toJson();
    jsonProfile.remove('documentID');

    try {
      await _users.doc(user.uid).set(jsonProfile);
      return profile;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Profile?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      DocumentSnapshot userDoc = await _users.doc(user.uid).get();
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      return Profile.fromJson({...data, 'documentID': user.uid, 'email': user.email});
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Profile?> updateProfile(Profile updatedProfile) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null || user.email != updatedProfile.email) return null;

    try {
      final updatedData =
          updatedProfile.toJson()
            ..remove('documentID')
            ..remove('email');

      await _users.doc(user.uid).update(updatedData);

      return updatedProfile.copyWith(email: user.email);
    } catch (e) {
      return null;
    }
  }
}
