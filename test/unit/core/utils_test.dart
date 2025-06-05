import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/core/utils.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), null);
        expect(Validators.validateEmail('user.name@domain.co.uk'), null);
        expect(Validators.validateEmail('test123@gmail.com'), null);
        expect(Validators.validateEmail('a@b.co'), null);
      });

      test('should return error message for null input', () {
        expect(Validators.validateEmail(null), 'Por favor ingresa tu correo');
      });

      test('should return error message for empty string', () {
        expect(Validators.validateEmail(''), 'Por favor ingresa tu correo');
      });

      test('should return error message for invalid email format', () {
        const expectedMessage = 'Ingresa un correo válido';
        expect(Validators.validateEmail('invalid'), expectedMessage);
        expect(Validators.validateEmail('test@'), expectedMessage);
        expect(Validators.validateEmail('@example.com'), expectedMessage);
        expect(Validators.validateEmail('test.example.com'), expectedMessage);
        expect(Validators.validateEmail('test@example'), expectedMessage);
        expect(Validators.validateEmail('test@@example.com'), expectedMessage);
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(Validators.validatePassword('Password123!'), null);
        expect(Validators.validatePassword('MySecure@Pass1'), null);
        expect(Validators.validatePassword('Test123@Password'), null);
        expect(Validators.validatePassword('Abc123456\$'), null);
      });

      test('should return error message for null input', () {
        expect(
          Validators.validatePassword(null),
          'Por favor ingresa tu contraseña',
        );
      });

      test('should return error message for empty string', () {
        expect(
          Validators.validatePassword(''),
          'Por favor ingresa tu contraseña',
        );
      });

      test('should return error message for password too short', () {
        const expectedMessage =
            'La contraseña debe tener entre 9 y 20 caracteres';
        expect(Validators.validatePassword('Test12!'), expectedMessage);
        expect(Validators.validatePassword('Abc12@'), expectedMessage);
      });

      test('should return error message for password too long', () {
        const expectedMessage =
            'La contraseña debe tener entre 9 y 20 caracteres';
        expect(
          Validators.validatePassword('ThisPasswordIsWayTooLong123456789!'),
          expectedMessage,
        );
      });

      test('should return error message for missing uppercase', () {
        const expectedMessage =
            'Debe contener: mayúscula, minúscula, número y símbolo';
        expect(Validators.validatePassword('password123!'), expectedMessage);
        expect(Validators.validatePassword('test12345@'), expectedMessage);
      });

      test('should return error message for missing lowercase', () {
        const expectedMessage =
            'Debe contener: mayúscula, minúscula, número y símbolo';
        expect(Validators.validatePassword('PASSWORD123!'), expectedMessage);
        expect(Validators.validatePassword('TEST12345@'), expectedMessage);
      });

      test('should return error message for missing number', () {
        const expectedMessage =
            'Debe contener: mayúscula, minúscula, número y símbolo';
        expect(Validators.validatePassword('Password!'), expectedMessage);
        expect(Validators.validatePassword('TestPass@'), expectedMessage);
      });

      test('should return error message for missing symbol', () {
        const expectedMessage =
            'Debe contener: mayúscula, minúscula, número y símbolo';
        expect(Validators.validatePassword('Password123'), expectedMessage);
        expect(Validators.validatePassword('TestPass1234'), expectedMessage);
      });

      test('should return error message for multiple missing requirements', () {
        const expectedMessage =
            'Debe contener: mayúscula, minúscula, número y símbolo';
        expect(
          Validators.validatePassword('passwordtooshort'),
          expectedMessage,
        );
      });
    });
  });
}
