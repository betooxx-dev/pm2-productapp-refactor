import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../../core/utils.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductEntity>> getProducts() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/products'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  @override
  Future<ProductEntity> getProduct(int id) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/products/$id'),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Error al cargar el producto $id: ${response.statusCode}',
      );
    }
  }
}
