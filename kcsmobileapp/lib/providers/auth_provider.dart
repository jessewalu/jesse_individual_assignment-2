import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestore = FirestoreService();

  User? _user;
  AppUser? profile;
  bool isLoading = false;
  String? error;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      if (user != null) {
        _loadProfile();
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null && _user!.emailVerified;
  String? get uid => _user?.uid;

  Future<void> signUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.signUp(email, password);
      if (user != null) {
        await _firestore.createUserProfile(user.uid, {
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
        });
      }
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _authService.signIn(email, password);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> _loadProfile() async {
    if (_user == null) return;
    final doc = await _firestore.usersRef.doc(_user!.uid).get();
    if (doc.exists) {
      profile = AppUser.fromMap(doc.data() as Map<String, dynamic>);
    }
  }
}
