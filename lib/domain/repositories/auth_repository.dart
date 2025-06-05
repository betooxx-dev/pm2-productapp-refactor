import '../entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<UserEntity?> signInWithEmailPassword(String email, String password);
  Future<void> signOut();
}
