import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:product_list_app/core/utils.dart';
import 'package:product_list_app/data/models/product_model.dart';
import 'dart:convert';
import 'package:product_list_app/data/repositories/product_repository_impl.dart';
import 'package:product_list_app/domain/entities/product_entity.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ProductRepositoryImpl', () {
    late ProductRepositoryImpl repository;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      // Inyectar el cliente mock
      repository = ProductRepositoryImplWithClient(mockClient);
    });

    group('getProducts', () {
      test('should return list of products on successful response', () async {
        final mockResponse = [
          {
            'id': 1,
            'title': 'Product 1',
            'description': 'Description 1',
            'price': 10.99,
          },
          {
            'id': 2,
            'title': 'Product 2',
            'description': 'Description 2',
            'price': 15.50,
          },
        ];

        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        final result = await repository.getProducts();

        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].title, 'Product 1');
        expect(result[1].id, 2);
        expect(result[1].title, 'Product 2');
      });

      test('should return empty list when API returns empty array', () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('[]', 200));

        final result = await repository.getProducts();

        expect(result, []);
      });

      test('should throw exception on 404 response', () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() => repository.getProducts(), throwsException);
      });

      test('should throw exception on 500 response', () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(() => repository.getProducts(), throwsException);
      });
    });

    group('getProduct', () {
      test('should return single product on successful response', () async {
        final mockResponse = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 29.99,
        };

        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        final result = await repository.getProduct(1);

        expect(result.id, 1);
        expect(result.title, 'Test Product');
        expect(result.description, 'Test Description');
        expect(result.price, 29.99);
      });

      test('should throw exception on 404 response', () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Product not found', 404));

        expect(() => repository.getProduct(999), throwsException);
      });

      test('should throw exception on malformed JSON', () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('invalid json', 200));

        expect(() => repository.getProduct(1), throwsException);
      });
    });
  });
}

// Clase auxiliar para inyectar el cliente HTTP mock
class ProductRepositoryImplWithClient extends ProductRepositoryImpl {
  final http.Client client;

  ProductRepositoryImplWithClient(this.client);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}/products'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  @override
  Future<ProductEntity> getProduct(int id) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}/products/$id'),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Error al cargar el producto $id: ${response.statusCode}',
      );
    }
  }
}
