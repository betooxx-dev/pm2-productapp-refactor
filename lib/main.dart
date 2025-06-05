import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'core/dependency_injection.dart';

import 'presentation/screens/user/home_screen.dart';
import 'presentation/screens/user/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA26EeLqN3IJg8pK9PkNEOyLFk9It2cKOo",
      appId: "1:197086191664:android:2a7af6c2f7e51fb5338df5",
      messagingSenderId: "197086191664",
      projectId: "momolongo-81518",
      storageBucket: "momolongo-81518.firebasestorage.app",
    ),
  );

  final user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(initialUser: user));
}

class MyApp extends StatelessWidget {
  final User? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DependencyInjection.getProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product List App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:
            initialUser == null
                ? LoginScreen()
                : HomeScreen(isCustomUser: false),
      ),
    );
  }
}
