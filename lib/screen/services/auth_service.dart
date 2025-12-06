import 'dart:convert';
import 'package:flutter_cakery_shop_ui/screen/utils/shared__pref.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:45471'; // Ej: http://192.168.1.100:5000/api
  
  Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await SharedPrefs.saveToken(data['token']);
        return {'success': true, 'data': data};
      } else {
        // Manejo de errores HTTP
        final errorData = response.statusCode == 400 || response.statusCode == 401
            ? jsonDecode(response.body)
            : {'message': 'Error ${response.statusCode}'};
        
        return {
          'success': false,
          'message': errorData['message'] ?? 'Credenciales incorrectas',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      // Manejo de errores de conexión
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String email, 
    String password, 
    String nombre,
    // Agrega otros campos que necesites
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'nombre': nombre,
          // otros campos
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Si el registro también retorna un token, guárdalo
        if (data['token'] != null) {
          await SharedPrefs.saveToken(data['token']);
        }
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Error en el registro',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Método adicional para logout
  Future<void> logout() async {
    await SharedPrefs.clearToken();
  }

  // Verificar si hay sesión activa
  Future<bool> isLoggedIn() async {
    final token = await SharedPrefs.getToken();
    return token != null && token.isNotEmpty;
  }
}