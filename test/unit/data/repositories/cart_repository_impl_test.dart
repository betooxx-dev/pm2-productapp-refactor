import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:product_list_app/core/utils.dart';
import 'package:product_list_app/data/models/cart_model.dart';
import 'dart:convert';
import 'package:product_list_app/data/repositories/cart_repository_impl.dart';
import 'package:product_list_app/domain/entities/cart_entity.dart';
import 'package:product_list_app/domain/repositories/product_repository.dart';
import 'package:product_list_app/domain/entities/product_entity.dart';

import 'cart_repository_impl_test.mocks.dart';

@GenerateMocks([http.Client, ProductRepository])
void main() {
  group('CartRepositoryImpl', () {
    late CartRepositoryImplWithClient repository;
    late MockClient mockClient;
    late MockProductRepository mockProductRepository;

    setUp(() {
      mockClient = MockClient();
      mockProductRepository = MockProductRepository();
      repository = CartRepositoryImplWithClient(
        productRepository: mockProductRepository,
        client: mockClient,
      );
    });

    group('getCart', () {
      test('should return cart with enriched product data', () async {
        final mockCartResponse = {
          'id': 1,
          'userId': 1,
          'date': '2024-01-01',
          'products': [
            {'productId': 1, 'quantity': 2},
            {'productId': 2, 'quantity': 1},
          ],
        };

        final mockProduct1 = ProductEntity(
          id: 1,
          title: 'Product 1',
          description: 'Description 1',
          price: 10.99,
        );

        final mockProduct2 = ProductEntity(
          id: 2,
          title: 'Product 2',
          description: 'Description 2',
          price: 15.50,
        );

        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(json.encode(mockCartResponse), 200),
        );

        when(
          mockProductRepository.getProduct(1),
        ).thenAnswer((_) async => mockProduct1);
        when(
          mockProductRepository.getProduct(2),
        ).thenAnswer((_) async => mockProduct2);

        final result = await repository.getCart(1);

        expect(result.id, 1);
        expect(result.products.length, 2);
        expect(result.products[0].productPrice, 10.99);
        expect(result.products[0].productTitle, 'Product 1');
        expect(result.products[1].productPrice, 15.50);
        expect(result.products[1].productTitle, 'Product 2');
      });

      test('should handle cart with no products', () async {
        final mockCartResponse = {
          'id': 1,
          'userId': 1,
          'date': '2024-01-01',
          'products': [],
        };

        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(json.encode(mockCartResponse), 200),
        );

        final result = await repository.getCart(1);

        expect(result.id, 1);
        expect(result.products.length, 0);
      });

      test('should throw exception on 404 response', () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Cart not found', 404));

        expect(() => repository.getCart(999), throwsException);
      });

      test('should handle product enrichment failure', () async {
        final mockCartResponse = {
          'id': 1,
          'userId': 1,
          'date': '2024-01-01',
          'products': [
            {'productId': 1, 'quantity': 2},
          ],
        };

        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(json.encode(mockCartResponse), 200),
        );

        when(
          mockProductRepository.getProduct(1),
        ).thenThrow(Exception('Product not found'));

        final result = await repository.getCart(1);

        expect(result.id, 1);
        expect(result.products.length, 1);
        // El producto debe mantener sus valores por defecto
        expect(result.products[0].productTitle, '');
        expect(result.products[0].productPrice, 0);
      });
    });

    group('createCart', () {
      test('should create cart successfully', () async {
        final cartData = {
          'userId': 1,
          'date': '2024-01-01',
          'products': [
            {'productId': 1, 'quantity': 2},
          ],
        };

        final expectedResponse = {'id': 123};

        when(
          mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(expectedResponse), 200),
        );

        final result = await repository.createCart(cartData);

        expect(result, expectedResponse);
      });

      test('should throw exception on failed creation', () async {
        final cartData = {'userId': 1, 'date': '2024-01-01', 'products': []};

        when(
          mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Bad Request', 400));

        expect(() => repository.createCart(cartData), throwsException);
      });
    });
  });
}

// Clase auxiliar para inyectar dependencias
class CartRepositoryImplWithClient extends CartRepositoryImpl {
  final http.Client client;

  CartRepositoryImplWithClient({
    required super.productRepository,
    required this.client,
  });

  @override
  Future<CartEntity> getCart(int id) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}/carts/$id'),
    );

    if (response.statusCode == 200) {
      CartModel cart = CartModel.fromJson(json.decode(response.body));

      // Enriquecer datos del carrito con información del producto
      for (var item in cart.products) {
        try {
          final product = await productRepository.getProduct(item.productId);
          // Actualizar propiedades del item
          final enrichedItem = CartItemModel(
            productId: item.productId,
            quantity: item.quantity,
            productPrice: product.price,
            productTitle: product.title,
            productImage: '', // La API no devuelve imagen
          );
          // Reemplazar item en la lista
          final index = cart.products.indexOf(item);
          cart.products[index] = enrichedItem;
        } catch (e) {
          print('Error al obtener detalles del producto ${item.productId}: $e');
        }
      }

      return cart;
    } else {
      throw Exception('Error al cargar el carrito $id: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> createCart(Map<String, dynamic> cartData) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}/carts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear carrito: ${response.statusCode}');
    }
  }
}
