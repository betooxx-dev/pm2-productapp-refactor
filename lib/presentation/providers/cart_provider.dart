import 'package:flutter/material.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/get_cart_usecase.dart';

class CartProvider with ChangeNotifier {
  final GetCartUseCase getCartUseCase;
  final CreateCartUseCase createCartUseCase;

  CartProvider({required this.getCartUseCase, required this.createCartUseCase});

  CartEntity? _cart;
  bool _isLoading = false;
  String? _error;

  CartEntity? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCart(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await getCartUseCase.call(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCart(Map<String, dynamic> cartData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await createCartUseCase.call(cartData);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryFetchCart(int id) {
    fetchCart(id);
  }
}
