import 'package:firebase_auth/firebase_auth.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<User?> call() async {
    return await repository.signInWithGoogle();
  }
}

class SignInWithEmailPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailPasswordUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    return await repository.signInWithEmailPassword(email, password);
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
