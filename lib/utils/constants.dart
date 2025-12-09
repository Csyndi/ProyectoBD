class ApiConstants {
  static const String baseUrl = 'http://localhost:5178/api'; // Cambia por tu URL
  static const Duration timeout = Duration(seconds: 30);
}

class ApiEndpoints {
  static const String productos = '/productos';
  static const String tiendas = '/tiendas';
  static const String usuarios = '/usuarios';
  static const String carritos = '/carritos';
  static const String ventas = '/ventas';
}