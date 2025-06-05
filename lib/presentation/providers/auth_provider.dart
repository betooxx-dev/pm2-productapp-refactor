import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthProvider with ChangeNotifier {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithEmailPasswordUseCase signInWithEmailPasswordUseCase;
  final SignOutUseCase signOutUseCase;

  AuthProvider({
    required this.signInWithGoogleUseCase,
    required this.signInWithEmailPasswordUseCase,
    required this.signOutUseCase,
  });

  User? _firebaseUser;
  UserEntity? _customUser;
  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  UserEntity? get customUser => _customUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _firebaseUser = await signInWithGoogleUseCase.call();
      return _firebaseUser != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customUser = await signInWithEmailPasswordUseCase.call(email, password);
      return _customUser != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await signOutUseCase.call();
    _firebaseUser = null;
    _customUser = null;
    notifyListeners();
  }
}
