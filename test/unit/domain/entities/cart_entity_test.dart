import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/domain/entities/cart_entity.dart';

void main() {
  group('CartEntity', () {
    group('total calculation', () {
      test('should return 0 when cart is empty', () {
        final cart = CartEntity(
          id: 1,
          userId: 1,
          date: '2024-01-01',
          products: [],
        );

        final total = cart.total;

        expect(total, 0.0);
      });

      test('should calculate total correctly with single item', () {
        final cartItem = CartItemEntity(
          productId: 1,
          quantity: 2,
          productPrice: 10.99,
          productTitle: 'Test Product',
          productImage: '',
        );

        final cart = CartEntity(
          id: 1,
          userId: 1,
          date: '2024-01-01',
          products: [cartItem],
        );

        final total = cart.total;

        expect(total, 21.98); // 2 * 10.99
      });

      test('should calculate total correctly with multiple items', () {
        final cartItems = [
          CartItemEntity(
            productId: 1,
            quantity: 2,
            productPrice: 10.50,
            productTitle: 'Product 1',
            productImage: '',
          ),
          CartItemEntity(
            productId: 2,
            quantity: 1,
            productPrice: 5.25,
            productTitle: 'Product 2',
            productImage: '',
          ),
          CartItemEntity(
            productId: 3,
            quantity: 3,
            productPrice: 7.99,
            productTitle: 'Product 3',
            productImage: '',
          ),
        ];

        final cart = CartEntity(
          id: 1,
          userId: 1,
          date: '2024-01-01',
          products: cartItems,
        );

        final total = cart.total;

        // (2 * 10.50) + (1 * 5.25) + (3 * 7.99) = 21.00 + 5.25 + 23.97 = 50.22
        expect(total, 50.22);
      });

      test('should handle zero price items', () {
        final cartItem = CartItemEntity(
          productId: 1,
          quantity: 5,
          productPrice: 0.0,
          productTitle: 'Free Product',
          productImage: '',
        );

        final cart = CartEntity(
          id: 1,
          userId: 1,
          date: '2024-01-01',
          products: [cartItem],
        );

        final total = cart.total;

        expect(total, 0.0);
      });

      test('should handle decimal quantities correctly', () {
        final cartItem = CartItemEntity(
          productId: 1,
          quantity: 0,
          productPrice: 15.99,
          productTitle: 'Product',
          productImage: '',
        );

        final cart = CartEntity(
          id: 1,
          userId: 1,
          date: '2024-01-01',
          products: [cartItem],
        );

        final total = cart.total;

        expect(total, 0.0);
      });
    });

    group('CartItemEntity constructor', () {
      test('should create CartItemEntity with all required fields', () {
        final cartItem = CartItemEntity(
          productId: 123,
          quantity: 5,
          productPrice: 29.99,
          productTitle: 'Test Product Title',
          productImage: 'https://example.com/image.jpg',
        );

        expect(cartItem.productId, 123);
        expect(cartItem.quantity, 5);
        expect(cartItem.productPrice, 29.99);
        expect(cartItem.productTitle, 'Test Product Title');
        expect(cartItem.productImage, 'https://example.com/image.jpg');
      });
    });
  });
}
