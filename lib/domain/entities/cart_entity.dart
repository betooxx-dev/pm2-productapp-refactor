class CartEntity {
  final int id;
  final int userId;
  final String date;
  final List<CartItemEntity> products;

  CartEntity({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  double get total => products.fold(
    0,
    (sum, item) => sum + (item.quantity * item.productPrice),
  );
}

class CartItemEntity {
  final int productId;
  final int quantity;
  final double productPrice;
  final String productTitle;
  final String productImage;

  CartItemEntity({
    required this.productId,
    required this.quantity,
    required this.productPrice,
    required this.productTitle,
    required this.productImage,
  });
}
