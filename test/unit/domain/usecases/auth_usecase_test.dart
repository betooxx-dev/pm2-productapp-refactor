import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_list_app/domain/entities/user_entity.dart';
import 'package:product_list_app/domain/repositories/auth_repository.dart';
import 'package:product_list_app/domain/usecases/auth_usecase.dart';

import 'auth_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository, User])
void main() {
  group('SignInWithGoogleUseCase', () {
    late SignInWithGoogleUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignInWithGoogleUseCase(mockRepository);
    });

    test('should return user when sign in successful', () async {
      final mockUser = MockUser();
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => mockUser);

      final result = await useCase.call();

      expect(result, mockUser);
      verify(mockRepository.signInWithGoogle()).called(1);
    });

    test('should return null when sign in cancelled', () async {
      when(mockRepository.signInWithGoogle()).thenAnswer((_) async => null);

      final result = await useCase.call();

      expect(result, null);
      verify(mockRepository.signInWithGoogle()).called(1);
    });

    test('should throw exception when sign in fails', () async {
      when(
        mockRepository.signInWithGoogle(),
      ).thenThrow(Exception('Google sign in failed'));

      expect(() => useCase.call(), throwsException);
      verify(mockRepository.signInWithGoogle()).called(1);
    });
  });

  group('SignInWithEmailPasswordUseCase', () {
    late SignInWithEmailPasswordUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignInWithEmailPasswordUseCase(mockRepository);
    });

    test('should return user entity when credentials are valid', () async {
      final mockUserEntity = UserEntity(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
        role: 'user',
        token: 'abc123',
      );

      when(
        mockRepository.signInWithEmailPassword(
          'test@example.com',
          'password123',
        ),
      ).thenAnswer((_) async => mockUserEntity);

      final result = await useCase.call('test@example.com', 'password123');

      expect(result, mockUserEntity);
      verify(
        mockRepository.signInWithEmailPassword(
          'test@example.com',
          'password123',
        ),
      ).called(1);
    });

    test('should return null when credentials are invalid', () async {
      when(
        mockRepository.signInWithEmailPassword('wrong@email.com', 'wrongpass'),
      ).thenAnswer((_) async => null);

      final result = await useCase.call('wrong@email.com', 'wrongpass');

      expect(result, null);
      verify(
        mockRepository.signInWithEmailPassword('wrong@email.com', 'wrongpass'),
      ).called(1);
    });

    test('should throw exception when sign in fails', () async {
      when(
        mockRepository.signInWithEmailPassword(
          'test@example.com',
          'password123',
        ),
      ).thenThrow(Exception('Authentication failed'));

      expect(
        () => useCase.call('test@example.com', 'password123'),
        throwsException,
      );
      verify(
        mockRepository.signInWithEmailPassword(
          'test@example.com',
          'password123',
        ),
      ).called(1);
    });
  });

  group('SignOutUseCase', () {
    late SignOutUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignOutUseCase(mockRepository);
    });

    test('should call repository sign out', () async {
      when(mockRepository.signOut()).thenAnswer((_) async => {});

      await useCase.call();

      verify(mockRepository.signOut()).called(1);
    });

    test('should throw exception when sign out fails', () async {
      when(mockRepository.signOut()).thenThrow(Exception('Sign out failed'));

      expect(() => useCase.call(), throwsException);
      verify(mockRepository.signOut()).called(1);
    });
  });
}
