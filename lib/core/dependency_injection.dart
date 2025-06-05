import 'package:provider/provider.dart';

import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';

import '../domain/repositories/product_repository.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_cart_usecase.dart';
import '../domain/usecases/auth_usecase.dart';

import '../presentation/providers/product_provider.dart';
import '../presentation/providers/cart_provider.dart';
import '../presentation/providers/auth_provider.dart';

class DependencyInjection {
  static List<ChangeNotifierProvider> getProviders() {
    final ProductRepository productRepository = ProductRepositoryImpl();
    final CartRepository cartRepository = CartRepositoryImpl(
      productRepository: productRepository,
    );
    final AuthRepository authRepository = AuthRepositoryImpl();

    final getProductsUseCase = GetProductsUseCase(productRepository);
    final getProductUseCase = GetProductUseCase(productRepository);
    final getCartUseCase = GetCartUseCase(cartRepository);
    final createCartUseCase = CreateCartUseCase(cartRepository);
    final signInWithGoogleUseCase = SignInWithGoogleUseCase(authRepository);
    final signInWithEmailPasswordUseCase = SignInWithEmailPasswordUseCase(
      authRepository,
    );
    final signOutUseCase = SignOutUseCase(authRepository);

    return [
      ChangeNotifierProvider<ProductProvider>(
        create:
            (_) => ProductProvider(
              getProductsUseCase: getProductsUseCase,
              getProductUseCase: getProductUseCase,
            ),
      ),
      ChangeNotifierProvider<CartProvider>(
        create:
            (_) => CartProvider(
              getCartUseCase: getCartUseCase,
              createCartUseCase: createCartUseCase,
            ),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create:
            (_) => AuthProvider(
              signInWithGoogleUseCase: signInWithGoogleUseCase,
              signInWithEmailPasswordUseCase: signInWithEmailPasswordUseCase,
              signOutUseCase: signOutUseCase,
            ),
      ),
    ];
  }
}
