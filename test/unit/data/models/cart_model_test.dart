import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/data/models/cart_model.dart';

void main() {
  group('CartModel', () {
    group('fromJson', () {
      test('should create CartModel from valid JSON', () {
        final json = {
          'id': 1,
          'userId': 1,
          'date': '2024-01-01',
          'products': [
            {'productId': 1, 'quantity': 2},
            {'productId': 2, 'quantity': 1},
          ],
        };

        final result = CartModel.fromJson(json);

        expect(result.id, 1);
        expect(result.userId, 1);
        expect(result.date, '2024-01-01');
        expect(result.products.length, 2);
        expect(result.products[0].productId, 1);
        expect(result.products[0].quantity, 2);
      });

      test('should handle empty products list', () {
        final json = {
          'id': 1,
          'userId': 1,
          'date': '2024-01-01',
          'products': [],
        };

        final result = CartModel.fromJson(json);

        expect(result.products.length, 0);
      });
    });
  });

  group('CartItemModel', () {
    group('fromJson', () {
      test('should create CartItemModel from valid JSON', () {
        final json = {'productId': 1, 'quantity': 3};

        final result = CartItemModel.fromJson(json);

        expect(result.productId, 1);
        expect(result.quantity, 3);
        expect(result.productPrice, 0);
        expect(result.productTitle, '');
        expect(result.productImage, '');
      });
    });

    group('toJson', () {
      test('should convert CartItemModel to JSON', () {
        final item = CartItemModel(
          productId: 1,
          quantity: 2,
          productPrice: 10.99,
          productTitle: 'Test Product',
          productImage: 'test.jpg',
        );

        final result = item.toJson();

        expect(result, {'productId': 1, 'quantity': 2});
      });
    });

    group('constructor', () {
      test('should create with all parameters', () {
        final item = CartItemModel(
          productId: 1,
          quantity: 2,
          productPrice: 15.99,
          productTitle: 'Product Title',
          productImage: 'image.jpg',
        );

        expect(item.productId, 1);
        expect(item.quantity, 2);
        expect(item.productPrice, 15.99);
        expect(item.productTitle, 'Product Title');
        expect(item.productImage, 'image.jpg');
      });

      test('should create with default values', () {
        final item = CartItemModel(productId: 1, quantity: 2);

        expect(item.productPrice, 0);
        expect(item.productTitle, '');
        expect(item.productImage, '');
      });
    });
  });

  group('CartRequestModel', () {
    group('toJson', () {
      test('should convert CartRequestModel to JSON', () {
        final cartItems = [
          CartItemModel(productId: 1, quantity: 2),
          CartItemModel(productId: 2, quantity: 1),
        ];

        final request = CartRequestModel(
          userId: 1,
          date: '2024-01-01',
          products: cartItems,
        );

        final result = request.toJson();

        expect(result, {
          'userId': 1,
          'date': '2024-01-01',
          'products': [
            {'productId': 1, 'quantity': 2},
            {'productId': 2, 'quantity': 1},
          ],
        });
      });

      test('should handle empty products list', () {
        final request = CartRequestModel(
          userId: 1,
          date: '2024-01-01',
          products: [],
        );

        final result = request.toJson();

        expect(result['products'], []);
      });
    });
  });
}
