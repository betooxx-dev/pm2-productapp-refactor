import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductProvider with ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final GetProductUseCase getProductUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.getProductUseCase,
  });

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  String? _error;

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await getProductsUseCase.call();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProductEntity?> fetchProduct(int id) async {
    try {
      return await getProductUseCase.call(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
