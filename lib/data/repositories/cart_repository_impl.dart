import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/cart_model.dart';
import '../../core/utils.dart';

class CartRepositoryImpl implements CartRepository {
  final ProductRepository productRepository;

  CartRepositoryImpl({required this.productRepository});

  @override
  Future<CartEntity> getCart(int id) async {
    final response = await http.get(
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
    final response = await http.post(
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
