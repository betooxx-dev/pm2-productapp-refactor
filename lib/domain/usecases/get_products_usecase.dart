import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getProducts();
  }
}

class GetProductUseCase {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  Future<ProductEntity> call(int id) async {
    return await repository.getProduct(id);
  }
}
