import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/data/models/auth_model.dart';

void main() {
  group('UserModel', () {
    final testUser = UserModel(
      id: '1',
      email: 'test@example.com',
      displayName: 'Test User',
      role: 'user',
      token: 'abc123',
    );

    group('fromJson', () {
      test('should create UserModel from valid JSON with all fields', () {
        final json = {
          'id': '1',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'token': 'abc123',
        };

        final result = UserModel.fromJson(json);

        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(result.displayName, 'Test User');
        expect(result.role, 'user');
        expect(result.token, 'abc123');
      });

      test('should handle integer id conversion', () {
        final json = {
          'id': 123,
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'token': 'abc123',
        };

        final result = UserModel.fromJson(json);

        expect(result.id, '123');
      });

      test('should handle null optional fields', () {
        final json = {
          'id': '1',
          'email': 'test@example.com',
          'displayName': null,
          'role': null,
          'token': null,
        };

        final result = UserModel.fromJson(json);

        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(result.displayName, null);
        expect(result.role, null);
        expect(result.token, null);
      });

      test('should handle missing optional fields', () {
        final json = {'id': '1', 'email': 'test@example.com'};

        final result = UserModel.fromJson(json);

        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(result.displayName, null);
        expect(result.role, null);
        expect(result.token, null);
      });
    });

    group('toJson', () {
      test('should convert UserModel to JSON', () {
        final result = testUser.toJson();

        expect(result, {
          'id': '1',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'role': 'user',
          'token': 'abc123',
        });
      });

      test('should handle null optional fields in toJson', () {
        final user = UserModel(id: '1', email: 'test@example.com');

        final result = user.toJson();

        expect(result, {
          'id': '1',
          'email': 'test@example.com',
          'displayName': null,
          'role': null,
          'token': null,
        });
      });
    });

    group('inheritance', () {
      test('should extend UserEntity', () {
        expect(testUser.id, '1');
        expect(testUser.email, 'test@example.com');
        expect(testUser.displayName, 'Test User');
        expect(testUser.role, 'user');
        expect(testUser.token, 'abc123');
      });
    });
  });
}
