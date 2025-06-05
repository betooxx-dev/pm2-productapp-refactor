import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:product_list_app/domain/entities/product_entity.dart';
import 'package:product_list_app/domain/repositories/product_repository.dart';
import 'package:product_list_app/domain/usecases/get_products_usecase.dart';

import 'get_products_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  group('GetProductsUseCase', () {
    late GetProductsUseCase useCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      useCase = GetProductsUseCase(mockRepository);
    });

    test('should return list of products from repository', () async {
      final mockProducts = [
        ProductEntity(
          id: 1,
          title: 'Product 1',
          description: 'Description 1',
          price: 10.99,
        ),
        ProductEntity(
          id: 2,
          title: 'Product 2',
          description: 'Description 2',
          price: 15.50,
        ),
      ];

      when(mockRepository.getProducts()).thenAnswer((_) async => mockProducts);

      final result = await useCase.call();

      expect(result, mockProducts);
      verify(mockRepository.getProducts()).called(1);
    });

    test(
      'should return empty list when repository returns empty list',
      () async {
        when(mockRepository.getProducts()).thenAnswer((_) async => []);

        final result = await useCase.call();

        expect(result, []);
        verify(mockRepository.getProducts()).called(1);
      },
    );

    test('should throw exception when repository throws exception', () async {
      when(mockRepository.getProducts()).thenThrow(Exception('Network error'));

      expect(() => useCase.call(), throwsException);
      verify(mockRepository.getProducts()).called(1);
    });
  });

  group('GetProductUseCase', () {
    late GetProductUseCase useCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      useCase = GetProductUseCase(mockRepository);
    });

    test(
      'should return product from repository when valid id is provided',
      () async {
        const productId = 1;
        final mockProduct = ProductEntity(
          id: productId,
          title: 'Test Product',
          description: 'Test Description',
          price: 20.99,
        );

        when(
          mockRepository.getProduct(productId),
        ).thenAnswer((_) async => mockProduct);

        final result = await useCase.call(productId);

        expect(result, mockProduct);
        verify(mockRepository.getProduct(productId)).called(1);
      },
    );

    test('should throw exception when repository throws exception', () async {
      const productId = 999;
      when(
        mockRepository.getProduct(productId),
      ).thenThrow(Exception('Product not found'));

      expect(() => useCase.call(productId), throwsException);
      verify(mockRepository.getProduct(productId)).called(1);
    });

    test('should call repository with correct id parameter', () async {
      const productId = 42;
      final mockProduct = ProductEntity(
        id: productId,
        title: 'Product 42',
        description: 'Description 42',
        price: 99.99,
      );

      when(
        mockRepository.getProduct(productId),
      ).thenAnswer((_) async => mockProduct);

      await useCase.call(productId);

      verify(mockRepository.getProduct(productId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
