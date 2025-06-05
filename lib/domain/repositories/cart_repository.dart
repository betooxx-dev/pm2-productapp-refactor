import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart(int id);
  Future<Map<String, dynamic>> createCart(Map<String, dynamic> cartData);
}
