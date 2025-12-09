// lib/screen/services/producto_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_cakery_shop_ui/screen/utils/shared__pref.dart';

class ProductoService {
  static const String baseUrl = 'https://localhost:7084/api';
  
  // Obtener todos los productos
  Future<List<Map<String, dynamic>>> getProductos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Productos'),
        headers: await _getHeaders(),
      );

      print('GetProductos status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> productos = [];
        
        for (var producto in data) {
          productos.add(_mapProductoFromApi(producto));
        }
        
        return productos;
      } else {
        print('Error al obtener productos: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error en getProductos: $e');
      return [];
    }
  }

  // Obtener productos por tienda
// ProductoService - Método clave para obtener productos por tienda
Future<List<Map<String, dynamic>>> getProductosPorTienda(int tiendaId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/Productos/tienda/$tiendaId'),
      headers: await _getHeaders(),
    );

    print('GetProductosPorTienda status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> productos = [];
      
      for (var producto in data) {
        productos.add(_mapProductoFromApi(producto));
      }
      
      return productos;
    } else {
      print('Error al obtener productos por tienda: ${response.body}');
      // Si no hay productos, retorna lista vacía
      return [];
    }
  } catch (e) {
    print('Error en getProductosPorTienda: $e');
    // En caso de error, puedes retornar datos de ejemplo
    return _getProductosEjemplo(tiendaId);
  }
}

// Productos de ejemplo para desarrollo
List<Map<String, dynamic>> _getProductosEjemplo(int tiendaId) {
  // Productos por tienda ID
  final productosPorTienda = {
    1: [ // Abarrotes Lupita
      {
        'id': '101',
        'name': 'Coca Cola 600ml',
        'description': 'Refresco de cola',
        'price': 18.0,
        'image': 'https://images.pexels.com/photos/50593/coca-cola-cold-drink-soft-drink-coke-50593.jpeg',
      },
      {
        'id': '102',
        'name': 'Sabritas Original',
        'description': 'Papas fritas',
        'price': 12.0,
        'image': 'https://images.pexels.com/photos/1448136/pexels-photo-1448136.jpeg',
      },
    ],
    2: [ // Ferretería El Martillo
      {
        'id': '201',
        'name': 'Martillo de Acero',
        'description': 'Martillo profesional',
        'price': 85.0,
        'image': 'https://images.pexels.com/photos/7931/pexels-photo.jpg',
      },
    ],
    3: [ // Pastelería Delicia
      {
        'id': '301',
        'name': 'Pastel de Chocolate',
        'description': 'Pastel casero',
        'price': 150.0,
        'image': 'https://images.pexels.com/photos/291528/pexels-photo-291528.jpeg',
      },
    ],
  };

  return productosPorTienda[tiendaId] ?? [];
}

  // Crear nuevo producto
  Future<Map<String, dynamic>> crearProducto({
  required String nombre,
  required String descripcion,
  required double precio,
  required int tiendaId,
  required int categoriaProductoId,
  required dynamic imagen,
}) async {
  try {
    // Construir cuerpo completo
    Map<String, dynamic> requestBody = {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'tiendaId': tiendaId,
      'categoriaProductoId': categoriaProductoId,
      'imagenUrl': imagen != null ? 'temp_url' : '', // Campo requerido
      'tienda': {
        'id': tiendaId,
        'nombre': 'Temp Tienda',
        // ... otros campos requeridos de Tienda
      },
      'categoriaProducto': {
        'id': categoriaProductoId,
        'nombre': 'Temp Categoria',
        // ... otros campos requeridos de CategoriaProducto
      },
      'detalleVentas': [], // Lista vacía pero presente
      'carritoDetalles': [], // Lista vacía pero presente
    };
    
    print('Request body: $requestBody');
    
    final response = await http.post(
      Uri.parse('$baseUrl/Productos'),
      headers: await _getHeaders(),
      body: jsonEncode(requestBody),
    );
    
    return _procesarRespuestaCreacion(response);
  } catch (e) {
    print('Error en crearProducto: $e');
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
}

  // Método auxiliar para procesar respuesta
  Map<String, dynamic> _procesarRespuestaCreacion(http.Response response) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'data': _mapProductoFromApi(data),
        'message': 'Producto creado exitosamente',
      };
    } else {
      String errorMessage = 'Error: ${response.statusCode}';
      
      try {
        final error = jsonDecode(response.body);
        if (error.containsKey('errors')) {
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

  // Obtener producto por ID
  Future<Map<String, dynamic>> getProductoById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Productos/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': _mapProductoFromApi(data),
        };
      } else {
        return {
          'success': false,
          'message': 'Error al obtener producto',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Actualizar producto
  Future<Map<String, dynamic>> actualizarProducto(int id, Map<String, dynamic> productoData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Productos/$id'),
        headers: await _getHeaders(),
        body: jsonEncode(productoData),
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Producto actualizado',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al actualizar producto',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Eliminar producto
  Future<Map<String, dynamic>> eliminarProducto(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/Productos/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Producto eliminado',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al eliminar producto',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Mapear producto desde la API a formato Flutter
  Map<String, dynamic> _mapProductoFromApi(dynamic productoApi) {
    // Construir URL de imagen si existe
    String imageUrl = '';
    if (productoApi['imagenUrl'] != null && productoApi['imagenUrl'].isNotEmpty) {
      if (productoApi['imagenUrl'].startsWith('http')) {
        imageUrl = productoApi['imagenUrl'];
      } else {
        // Si es ruta relativa, construir URL completa
        imageUrl = '$baseUrl${productoApi['imagenUrl']}';
      }
    }
    
    return {
      'id': productoApi['id']?.toString(),
      'name': productoApi['nombre'] ?? 'Sin nombre',
      'description': productoApi['descripcion'] ?? '',
      'price': productoApi['precio']?.toDouble() ?? 0.0,
      'tiendaId': productoApi['tiendaId']?.toString(),
      'categoriaProductoId': productoApi['categoriaProductoId']?.toString(),
      'categoriaNombre': productoApi['categoriaProducto']?['nombre'] ?? 'General',
      'tiendaNombre': productoApi['tienda']?['nombre'] ?? '',
      'imagenUrl': imageUrl,
      'image': imageUrl.isNotEmpty 
          ? imageUrl 
          : 'https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg',
    };
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