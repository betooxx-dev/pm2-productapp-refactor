import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<CartEntity> call(int id) async {
    return await repository.getCart(id);
  }
}

class CreateCartUseCase {
  final CartRepository repository;

  CreateCartUseCase(this.repository);

  Future<Map<String, dynamic>> call(Map<String, dynamic> cartData) async {
    return await repository.createCart(cartData);
  }
}
