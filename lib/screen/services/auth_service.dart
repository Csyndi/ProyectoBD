import 'dart:convert';
import 'package:flutter_cakery_shop_ui/screen/utils/shared__pref.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Asegúrate de que esta URL sea correcta para tu API
  //static const String baseUrl = 'https://10.0.2.2:7084/api'; // Para Android emulador
   static const String baseUrl = 'https://localhost:7084/api'; // Para web/desktop
  // static const String baseUrl = 'http://192.168.1.X:7084/api'; // Para dispositivo físico

  Future<Map<String, dynamic>> login(String email, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Usuarios/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'contrasena': contrasena, // ¡Importante! En tu API es 'contrasena', no 'password'
        }),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Verifica la estructura de la respuesta
        print('Login response: $data');
        
        // Si tu API retorna el usuario directamente, procesa los datos
        if (data is Map<String, dynamic>) {
          // Guarda el ID del usuario o cualquier dato que necesites
          await SharedPrefs.saveUserId(data['id']?.toString() ?? '');
          await SharedPrefs.saveUserEmail(data['email'] ?? '');
          await SharedPrefs.saveUserName(data['nombre'] ?? '');
          
          // Si necesitas token JWT, ajusta según lo que devuelva tu API
          // await SharedPrefs.saveToken(data['token'] ?? '');
          
          return {
            'success': true,
            'data': data,
            'message': 'Login exitoso',
          };
        }
        
        return {
          'success': true,
          'data': data,
          'message': 'Login exitoso',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Correo o contraseña incorrectos',
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Error en el servidor: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
Future<Map<String, dynamic>> register(
  String email, 
  String contrasena, 
  String nombre,
) async {
  try {
    // PRIMERO: Prueba con la estructura EXACTA que muestra Swagger
   final Map<String, dynamic> usuarioData = {
  "nombre": nombre,
  "email": email,
  "contrasena": contrasena,
  "rol": "cliente",
  "activo": true,
  // "fechaCreacion": DateTime.now().toUtc().toIso8601String(), // COMENTADO
};
    
    print('=== ENVIANDO A API ===');
    print('URL: $baseUrl/Usuarios');
    print('Body completo: ${jsonEncode(usuarioData)}');
    
    final response = await http.post(
      Uri.parse('$baseUrl/Usuarios'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(usuarioData),
    );

    print('=== RESPUESTA CRUDA ===');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
    print('Headers: ${response.headers}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      
      await SharedPrefs.saveUserId(data['id']?.toString() ?? '');
      await SharedPrefs.saveUserEmail(data['email'] ?? '');
      await SharedPrefs.saveUserName(data['nombre'] ?? '');
      
      return {
        'success': true,
        'data': data,
        'message': 'Registro exitoso',
      };
    } else {
      // Para error 500, intenta obtener más información
      String errorBody = response.body;
      Map<String, dynamic>? errorDetails;
      
      try {
        errorDetails = jsonDecode(errorBody);
      } catch (e) {
        // Si no es JSON, usa el texto plano
      }
      
      String errorMessage = 'Error ${response.statusCode}';
      
      if (response.statusCode == 500) {
        errorMessage = 'Error interno del servidor (500)';
        if (errorBody.contains('SqlException') || errorBody.contains('DbUpdateException')) {
          errorMessage = 'Error de base de datos. Verifica los datos.';
        }
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'statusCode': response.statusCode,
        'responseBody': errorBody,
        'errorDetails': errorDetails,
      };
    }
  } catch (e) {
    print('=== ERROR EN HTTP ===');
    print('Exception: $e');
    print('Stack: ${e.toString()}');
    
    return {
      'success': false,
      'message': 'Error de conexión: ${e.toString()}',
    };
  }
}
  // Método para actualizar usuario
  Future<Map<String, dynamic>> updateUser(
    int id, 
    Map<String, dynamic> userData
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Usuarios/$id'),
        headers: await _getHeaders(),
        body: jsonEncode(userData),
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Usuario actualizado',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al actualizar usuario',
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

  Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> logout() async {
    await SharedPrefs.clearToken();
    await SharedPrefs.clearUserId();
    await SharedPrefs.clearUserEmail();
    await SharedPrefs.clearUserName();
  }

  Future<bool> isLoggedIn() async {
    final userId = await SharedPrefs.getUserId();
    return userId != null && userId.isNotEmpty;
  }
}