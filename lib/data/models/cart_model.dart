import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  CartModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      products:
          (json['products'] as List)
              .map((item) => CartItemModel.fromJson(item))
              .toList(),
    );
  }
}

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.productId,
    required super.quantity,
    super.productPrice = 0,
    super.productTitle = '',
    super.productImage = '',
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }
}

class CartRequestModel {
  final int userId;
  final String date;
  final List<CartItemModel> products;

  CartRequestModel({
    required this.userId,
    required this.date,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}
