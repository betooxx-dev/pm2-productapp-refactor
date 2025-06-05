import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isCustomUser;

  HomeScreen({super.key, required this.isCustomUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (isCustomUser && authProvider.customUser != null) {
              return Text(
                'Hola ${authProvider.customUser!.role?.toUpperCase() ?? 'Usuario'}',
              );
            } else if (!isCustomUser && authProvider.firebaseUser != null) {
              return Text(
                'Hola ${authProvider.firebaseUser!.displayName ?? 'Usuario'}',
              );
            }
            return Text('Hola Usuario');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.signOut();
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ProductListScreen(),
    );
  }
}
