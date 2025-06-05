import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String customBaseUrl = 'http://10.0.2.2:3000';
  static const String dummyJsonUrl = 'https://dummyjson.com/products';
}

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 9 || value.length > 20) {
      return 'La contraseña debe tener entre 9 y 20 caracteres';
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
    ).hasMatch(value)) {
      return 'Debe contener: mayúscula, minúscula, número y símbolo';
    }
    return null;
  }
}

class Utils {
  static void showSnackBar(context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

class FirebaseConfig {
  static const firebaseOptions = {
    'apiKey': "AIzaSyA26EeLqN3IJg8pK9PkNEOyLFk9It2cKOo",
    'appId': "1:197086191664:android:2a7af6c2f7e51fb5338df5",
    'messagingSenderId': "197086191664",
    'projectId': "momolongo-81518",
    'storageBucket': "momolongo-81518.firebasestorage.app",
  };
}
