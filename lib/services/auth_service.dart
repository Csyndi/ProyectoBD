import 'dart:convert';
import 'package:flutter_cakery_shop_ui/utils/shared__pref.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:5178/api';

  Future<Map<String, dynamic>> login(String email, String contrasena) async {
    try {
      // Primero: Obtener todos los usuarios o buscar por email
      // Dependiendo de cómo esté configurada tu API, podrías necesitar:
      
      // Opción 1: Si tu API tiene endpoint para buscar por email
      final response = await http.get(
        Uri.parse('$baseUrl/Usuarios?email=$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      // Opción 2: Si tu API devuelve todos los usuarios y los filtramos localmente
      // final response = await http.get(
      //   Uri.parse('$baseUrl/Usuarios'),
      //   headers: {'Content-Type': 'application/json'},
      // );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Dependiendo de la estructura de respuesta de tu API:
        List<dynamic> usuarios = [];
        
        if (data is List) {
          // Si la API devuelve una lista directamente
          usuarios = data;
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          // Si la API devuelve un objeto con propiedad 'data'
          usuarios = data['data'] is List ? data['data'] : [];
        } else if (data is Map<String, dynamic>) {
          // Si la API devuelve un solo usuario directamente
          usuarios = [data];
        }
        
        // Buscar el usuario por email y contraseña
        final usuarioEncontrado = usuarios.firstWhere(
          (usuario) => 
            usuario['email'] == email && 
            usuario['contrasena'] == contrasena, // ¡Cuidado! Esto no es seguro
          orElse: () => null,
        );
        
        if (usuarioEncontrado != null) {
          // Guardar datos del usuario
          await SharedPrefs.saveUserId(usuarioEncontrado['id']?.toString() ?? '');
          await SharedPrefs.saveUserEmail(usuarioEncontrado['email'] ?? '');
          await SharedPrefs.saveUserName(usuarioEncontrado['nombre'] ?? '');
          await SharedPrefs.saveUserRol(usuarioEncontrado['rol'] ?? 'cliente');
          
          return {
            'success': true,
            'data': usuarioEncontrado,
            'message': 'Login exitoso',
          };
        } else {
          return {
            'success': false,
            'message': 'Correo o contraseña incorrectos',
            'statusCode': 401,
          };
        }
      } else if (response.statusCode == 404) {
        // Si no encuentra el usuario
        return {
          'success': false,
          'message': 'Usuario no encontrado',
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

  // Método alternativo si tu API soporta búsqueda específica
  Future<Map<String, dynamic>> loginWithFilter(String email, String contrasena) async {
    try {
      // Si tu API soporta filtros complejos en GET
      final response = await http.get(
        Uri.parse('$baseUrl/Usuarios'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> usuarios = jsonDecode(response.body);
        
        // Filtrar localmente
        final usuario = usuarios.firstWhere(
          (u) => u['email'] == email && u['contrasena'] == contrasena,
          orElse: () => null,
        );
        
        if (usuario != null) {
          // Guardar datos
          await SharedPrefs.saveUserId(usuario['id']?.toString() ?? '');
          await SharedPrefs.saveUserEmail(usuario['email'] ?? '');
          await SharedPrefs.saveUserName(usuario['nombre'] ?? '');
          
          return {
            'success': true,
            'data': usuario,
            'message': 'Login exitoso',
          };
        } else {
          return {
            'success': false,
            'message': 'Credenciales incorrectas',
            'statusCode': 401,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Error al obtener usuarios',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String email, 
    String contrasena, 
    String nombre,
  ) async {
    try {
     
      // Crear nuevo usuario
      final Map<String, dynamic> usuarioData = {
        "nombre": nombre,
        "email": email,
        "contrasena": contrasena,
        "rol": "cliente",
        "activo": true,
      };
      
      final response = await http.post(
        Uri.parse('$baseUrl/Usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuarioData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Guardar datos automáticamente después del registro
        await SharedPrefs.saveUserId(data['id']?.toString() ?? '');
        await SharedPrefs.saveUserEmail(data['email'] ?? '');
        await SharedPrefs.saveUserName(data['nombre'] ?? '');
        await SharedPrefs.saveUserRol(data['rol'] ?? 'cliente');
        
        return {
          'success': true,
          'data': data,
          'message': 'Registro exitoso',
        };
      } else {
        return {
          'success': false,
          'message': 'Error en el registro: ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Método para obtener usuario por ID (útil para perfil)
  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Usuarios/$id'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener usuario',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
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

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Actualizar datos locales si es necesario
        if (userData.containsKey('nombre')) {
          await SharedPrefs.saveUserName(userData['nombre']);
        }
        if (userData.containsKey('email')) {
          await SharedPrefs.saveUserEmail(userData['email']);
        }
        
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
    // Si tu API usa autenticación, ajusta esto
    return {
      'Content-Type': 'application/json',
      // Si necesitas token:
      // 'Authorization': 'Bearer ${await SharedPrefs.getToken()}',
    };
  }

  Future<void> logout() async {
    await SharedPrefs.clearUserId();
    await SharedPrefs.clearUserEmail();
    await SharedPrefs.clearUserName();
    await SharedPrefs.clearUserRol();
  }

  Future<bool> isLoggedIn() async {
    final userId = await SharedPrefs.getUserId();
    return userId != null && userId.isNotEmpty;
  }

  // Método para verificar si el usuario es administrador
  Future<bool> isAdmin() async {
    final rol = await SharedPrefs.getUserRol();
    return rol == 'admin' || rol == 'administrador';
  }
}