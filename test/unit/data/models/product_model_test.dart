import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    final testProduct = ProductModel(
      id: 1,
      title: 'Test Product',
      description: 'Test Description',
      price: 29.99,
    );

    group('fromJson', () {
      test('should create ProductModel from valid JSON', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 29.99,
        };

        final result = ProductModel.fromJson(json);

        expect(result.id, 1);
        expect(result.title, 'Test Product');
        expect(result.description, 'Test Description');
        expect(result.price, 29.99);
      });

      test('should handle integer price', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 30,
        };

        final result = ProductModel.fromJson(json);

        expect(result.price, 30.0);
      });

      test('should handle double price', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 29.99,
        };

        final result = ProductModel.fromJson(json);

        expect(result.price, 29.99);
      });
    });

    group('toJson', () {
      test('should convert ProductModel to JSON', () {
        final result = testProduct.toJson();

        expect(result, {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 29.99,
        });
      });

      test('should handle zero price', () {
        final product = ProductModel(
          id: 1,
          title: 'Free Product',
          description: 'Free Description',
          price: 0.0,
        );

        final result = product.toJson();

        expect(result['price'], 0.0);
      });
    });

    group('inheritance', () {
      test('should extend ProductEntity', () {
        expect(testProduct.id, 1);
        expect(testProduct.title, 'Test Product');
        expect(testProduct.description, 'Test Description');
        expect(testProduct.price, 29.99);
      });
    });
  });
}
