import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:product_list_app/domain/entities/cart_entity.dart';
import 'package:product_list_app/domain/repositories/cart_repository.dart';
import 'package:product_list_app/domain/usecases/get_cart_usecase.dart';

import 'get_cart_usecase_test.mocks.dart';

@GenerateMocks([CartRepository])
void main() {
  group('GetCartUseCase', () {
    late GetCartUseCase useCase;
    late MockCartRepository mockRepository;

    setUp(() {
      mockRepository = MockCartRepository();
      useCase = GetCartUseCase(mockRepository);
    });

    test('should return cart from repository', () async {
      final mockCart = CartEntity(
        id: 1,
        userId: 1,
        date: '2024-01-01',
        products: [
          CartItemEntity(
            productId: 1,
            quantity: 2,
            productPrice: 10.99,
            productTitle: 'Test Product',
            productImage: '',
          ),
        ],
      );

      when(mockRepository.getCart(1)).thenAnswer((_) async => mockCart);

      final result = await useCase.call(1);

      expect(result, mockCart);
      verify(mockRepository.getCart(1)).called(1);
    });

    test('should throw exception when cart not found', () async {
      when(mockRepository.getCart(999)).thenThrow(Exception('Cart not found'));

      expect(() => useCase.call(999), throwsException);
      verify(mockRepository.getCart(999)).called(1);
    });

    test('should throw exception when repository fails', () async {
      when(mockRepository.getCart(1)).thenThrow(Exception('Network error'));

      expect(() => useCase.call(1), throwsException);
      verify(mockRepository.getCart(1)).called(1);
    });
  });

  group('CreateCartUseCase', () {
    late CreateCartUseCase useCase;
    late MockCartRepository mockRepository;

    setUp(() {
      mockRepository = MockCartRepository();
      useCase = CreateCartUseCase(mockRepository);
    });

    test('should create cart successfully', () async {
      final cartData = {
        'userId': 1,
        'date': '2024-01-01',
        'products': [
          {'productId': 1, 'quantity': 2},
        ],
      };

      final expectedResponse = {'id': 123, 'message': 'Cart created'};

      when(
        mockRepository.createCart(cartData),
      ).thenAnswer((_) async => expectedResponse);

      final result = await useCase.call(cartData);

      expect(result, expectedResponse);
      verify(mockRepository.createCart(cartData)).called(1);
    });

    test('should throw exception when repository fails', () async {
      final cartData = {'userId': 1, 'date': '2024-01-01', 'products': []};

      when(
        mockRepository.createCart(cartData),
      ).thenThrow(Exception('Failed to create cart'));

      expect(() => useCase.call(cartData), throwsException);
      verify(mockRepository.createCart(cartData)).called(1);
    });

    test('should handle empty cart data', () async {
      final cartData = <String, dynamic>{};
      final expectedResponse = {'error': 'Invalid data'};

      when(
        mockRepository.createCart(cartData),
      ).thenAnswer((_) async => expectedResponse);

      final result = await useCase.call(cartData);

      expect(result, expectedResponse);
      verify(mockRepository.createCart(cartData)).called(1);
    });
  });
}
