import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/screen/home_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/login_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/register_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiendita',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          // Obtener argumentos pasados
          final args = settings.arguments as Map<String, dynamic>?;
          final usuarioId = args?['usuarioId'];
          
          return MaterialPageRoute(
            builder: (context) => HomeScreen(usuarioId: usuarioId),
          );
        }
        return null;
      },
    );
  }
}