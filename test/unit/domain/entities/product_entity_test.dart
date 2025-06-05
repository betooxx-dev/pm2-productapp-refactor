import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity', () {
    test('should create product entity with all required fields', () {
      final product = ProductEntity(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
      );

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.description, 'Test Description');
      expect(product.price, 29.99);
    });

    test('should handle zero price', () {
      final product = ProductEntity(
        id: 1,
        title: 'Free Product',
        description: 'Free Description',
        price: 0.0,
      );

      expect(product.price, 0.0);
    });

    test('should handle decimal prices', () {
      final product = ProductEntity(
        id: 1,
        title: 'Decimal Product',
        description: 'Decimal Description',
        price: 19.99,
      );

      expect(product.price, 19.99);
    });
  });
}
