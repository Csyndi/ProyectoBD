// lib/screen/services/tienda_service.dart
import 'dart:convert';
import 'dart:io'; // ¡IMPORTANTE: Falta este import!
import 'package:flutter_cakery_shop_ui/screen/utils/shared__pref.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb; // Para detectar si es web

class TiendaService {
  // Usa la misma baseUrl que tu AuthService
  static const String baseUrl = 'https://localhost:7084/api';
  
  // Obtener todas las tiendas
  Future<List<Map<String, dynamic>>> getTiendas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Tiendas'),
        headers: await _getHeaders(),
      );

      print('GetTiendas status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> tiendas = [];
        
        for (var tienda in data) {
          tiendas.add(_mapTiendaFromApi(tienda));
        }
        
        return tiendas;
      } else {
        print('Error al obtener tiendas: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error en getTiendas: $e');
      return [];
    }
  }

  // Obtener tiendas por usuario
  Future<List<Map<String, dynamic>>> getTiendasPorUsuario() async {
    try {
      final userId = await SharedPrefs.getUserId();
      if (userId == null || userId.isEmpty) {
        return [];
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/Tiendas/usuario/$userId'),
        headers: await _getHeaders(),
      );

      print('GetTiendasPorUsuario status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> tiendas = [];
        
        for (var tienda in data) {
          tiendas.add(_mapTiendaFromApi(tienda));
        }
        
        return tiendas;
      } else {
        print('Error al obtener tiendas por usuario: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error en getTiendasPorUsuario: $e');
      return [];
    }
  }

  // Crear nueva tienda
  // En tienda_service.dart - REEMPLAZA EL MÉTODO crearTienda
Future<Map<String, dynamic>> crearTienda({
  required String nombre,
  required String descripcion,
  required String direccion,
  required String telefono,
  required int categoriaId,
  required dynamic imagen,
}) async {
  try {
    // 1. OBTENER USUARIO ID (REQUERIDO)
    final userId = await SharedPrefs.getUserId();
    if (userId == null || userId.isEmpty) {
      return {'success': false, 'message': 'Usuario no autenticado'};
    }
    
    // 2. VALIDAR CATEGORÍA ID (NO PUEDE SER 0)
    if (categoriaId <= 0) {
      return {'success': false, 'message': 'Selecciona una categoría válida'};
    }
    
    print('=== DATOS QUE SE ENVIARÁN ===');
    print('Usuario ID: $userId');
    print('Categoría ID: $categoriaId');
    print('Nombre: $nombre');
    print('Descripción: $descripcion');
    print('Dirección: $direccion');
    print('Teléfono: $telefono');
    
    // ✅ PARA TODAS LAS PLATAFORMAS: Usar JSON sin imagen temporalmente
    Map<String, dynamic> requestBody = {
      'nombre': nombre,
      'descripcion': descripcion,
      'direccion': direccion,
      'telefono': telefono,
      'usuarioId': int.parse(userId), // ¡IMPORTANTE!
      'categoriaId': categoriaId,      // ¡IMPORTANTE! No puede ser 0
    };
    
    print('Request body JSON: $requestBody');
    
    final response = await http.post(
      Uri.parse('$baseUrl/Tiendas'), // ✅ ENDPOINT QUE SÍ EXISTE
      headers: await _getHeaders(),
      body: jsonEncode(requestBody),
    );
    
    return _procesarRespuestaCreacion(response);
    
  } catch (e) {
    print('Error en crearTienda: $e');
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
}

  // Método auxiliar para procesar respuesta de creación
  Map<String, dynamic> _procesarRespuestaCreacion(http.Response response) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'data': _mapTiendaFromApi(data),
        'message': 'Tienda creada exitosamente',
      };
    } else {
      String errorMessage = 'Error: ${response.statusCode}';
      
      try {
        final error = jsonDecode(response.body);
        if (error.containsKey('errors')) {
          // Procesar errores de validación de ASP.NET Core
          final errors = error['errors'] as Map<String, dynamic>;
          final errorMessages = <String>[];
          
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.cast<String>());
            }
          });
          
          if (errorMessages.isNotEmpty) {
            errorMessage = errorMessages.join('\n');
          }
        } else if (error.containsKey('title')) {
          errorMessage = error['title'];
        } else if (error is String) {
          errorMessage = error;
        }
      } catch (e) {
        print('Error parseando respuesta: $e');
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'statusCode': response.statusCode,
      };
    }
  }

  // Obtener tienda por ID
  Future<Map<String, dynamic>> getTiendaById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Tiendas/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': _mapTiendaFromApi(data),
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener tienda',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Actualizar tienda
  Future<Map<String, dynamic>> actualizarTienda(int id, Map<String, dynamic> tiendaData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Tiendas/$id'),
        headers: await _getHeaders(),
        body: jsonEncode(tiendaData),
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Tienda actualizada',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al actualizar tienda',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Eliminar tienda
  Future<Map<String, dynamic>> eliminarTienda(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/Tiendas/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Tienda eliminada',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al eliminar tienda',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Mapear tienda desde la API a formato Flutter
  Map<String, dynamic> _mapTiendaFromApi(dynamic tiendaApi) {
    // Construir URL de imagen si existe
    String imageUrl = '';
    if (tiendaApi['imagenUrl'] != null && tiendaApi['imagenUrl'].isNotEmpty) {
      if (tiendaApi['imagenUrl'].startsWith('http')) {
        imageUrl = tiendaApi['imagenUrl'];
      } else {
        // Si es ruta relativa, construir URL completa
        imageUrl = '$baseUrl${tiendaApi['imagenUrl']}';
      }
    }
    
    return {
      'id': tiendaApi['id']?.toString(),
      'name': tiendaApi['nombre'] ?? 'Sin nombre',
      'description': tiendaApi['descripcion'] ?? '',
      'direccion': tiendaApi['direccion'] ?? '',
      'telefono': tiendaApi['telefono'] ?? '',
      'usuarioId': tiendaApi['usuarioId']?.toString(),
      'categoriaId': tiendaApi['categoriaId']?.toString(),
      'category': tiendaApi['categoria']?['nombre'] ?? 'General',
      'usuarioNombre': tiendaApi['usuario']?['nombre'] ?? '',
      'imagenUrl': imageUrl,
      'image': imageUrl.isNotEmpty 
          ? imageUrl 
          : _getDefaultImage(tiendaApi['categoria']?['nombre'] ?? 'General'),
      'products': [], // Los productos se cargarán por separado
    };
  }

  // Obtener imagen por defecto según categoría
  String _getDefaultImage(String categoria) {
    final categoriasImagenes = {
      'Abarrotes': 'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg',
      'Ferretería': 'https://images.pexels.com/photos/4481326/pexels-photo-4481326.jpeg',
      'Pastelería': 'https://images.pexels.com/photos/533325/pexels-photo-533325.jpeg',
      'Restaurante': 'https://images.pexels.com/photos/941861/pexels-photo-941861.jpeg',
      'Ropa': 'https://images.pexels.com/photos/994523/pexels-photo-994523.jpeg',
      'Electrónica': 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg',
      'General': 'https://images.pexels.com/photos/439227/pexels-photo-439227.jpeg',
    };
    
    return categoriasImagenes[categoria] ?? categoriasImagenes['General']!;
  }

  // Headers con autenticación
  Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}