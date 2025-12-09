import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/tienda.dart';
import '../models/producto.dart';
import '../models/carrito.dart';
import '../models/venta.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:5178/api'; // Cambia por tu URL

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // Headers comunes
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Manejo de errores
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // ========== USUARIOS ==========

  Future<List<Usuario>> getUsuarios() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/usuarios'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Usuario.fromJson(json)).toList();
  }

  Future<Usuario> getUsuario(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/usuarios/$id'),
      headers: _headers,
    );
    
    _handleError(response);
    
    return Usuario.fromJson(json.decode(response.body));
  }

  Future<Usuario> createUsuario(Usuario usuario) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: _headers,
      body: json.encode(usuario.toJson()),
    );
    
    _handleError(response);
    
    return Usuario.fromJson(json.decode(response.body));
  }

  Future<void> updateUsuario(int id, Usuario usuario) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/usuarios/$id'),
      headers: _headers,
      body: json.encode(usuario.toJson()),
    );
    
    _handleError(response);
  }

  Future<void> deleteUsuario(int id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/usuarios/$id'),
      headers: _headers,
    );
    
    _handleError(response);
  }

  // ========== TIENDAS ==========

  Future<List<Tienda>> getTiendas() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tiendas'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Tienda.fromJson(json)).toList();
  }

  Future<Tienda> getTienda(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tiendas/$id'),
      headers: _headers,
    );
    
    _handleError(response);
    
    return Tienda.fromJson(json.decode(response.body));
  }

  Future<List<Tienda>> getTiendasPorUsuario(int usuarioId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tiendas/usuario/$usuarioId'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Tienda.fromJson(json)).toList();
  }

  Future<Tienda> createTienda(Tienda tienda) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/tiendas'),
      headers: _headers,
      body: json.encode(tienda.toJson()),
    );
    
    _handleError(response);
    
    return Tienda.fromJson(json.decode(response.body));
  }

  Future<void> updateTienda(int id, Tienda tienda) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/tiendas/$id'),
      headers: _headers,
      body: json.encode(tienda.toJson()),
    );
    
    _handleError(response);
  }

  Future<void> deleteTienda(int id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/tiendas/$id'),
      headers: _headers,
    );
    
    _handleError(response);
  }

  // ========== PRODUCTOS ==========

  Future<List<Producto>> getProductos() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/productos'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Producto.fromJson(json)).toList();
  }

  Future<Producto> getProducto(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers,
    );
    
    _handleError(response);
    
    return Producto.fromJson(json.decode(response.body));
  }

  Future<List<Producto>> getProductosPorTienda(int tiendaId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/productos/tienda/$tiendaId'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Producto.fromJson(json)).toList();
  }

  Future<Producto> createProducto(Producto producto) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/productos'),
      headers: _headers,
      body: json.encode(producto.toJson()),
    );
    
    _handleError(response);
    
    return Producto.fromJson(json.decode(response.body));
  }

  Future<void> updateProducto(int id, Producto producto) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers,
      body: json.encode(producto.toJson()),
    );
    
    _handleError(response);
  }

  Future<void> deleteProducto(int id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/productos/$id'),
      headers: _headers,
    );
    
    _handleError(response);
  }

  // ========== CARRITOS ==========

  Future<List<Carrito>> getCarritos() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/carritos'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Carrito.fromJson(json)).toList();
  }

  Future<Carrito> getCarrito(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/carritos/$id'),
      headers: _headers,
    );
    
    _handleError(response);
    
    return Carrito.fromJson(json.decode(response.body));
  }

  Future<List<Carrito>> getCarritosPorUsuario(int usuarioId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/carritos/usuario/$usuarioId'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Carrito.fromJson(json)).toList();
  }

  Future<Carrito> createCarrito(Carrito carrito) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/carritos'),
      headers: _headers,
      body: json.encode(carrito.toJson()),
    );
    
    _handleError(response);
    
    return Carrito.fromJson(json.decode(response.body));
  }

  Future<void> updateCarrito(int id, Carrito carrito) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/carritos/$id'),
      headers: _headers,
      body: json.encode(carrito.toJson()),
    );
    
    _handleError(response);
  }

  Future<void> deleteCarrito(int id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/carritos/$id'),
      headers: _headers,
    );
    
    _handleError(response);
  }

  Future<void> deleteCarritosPorUsuario(int usuarioId) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/carritos/usuario/$usuarioId'),
      headers: _headers,
    );
    
    _handleError(response);
  }

  // ========== VENTAS ==========

  Future<List<Venta>> getVentas() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/ventas'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Venta.fromJson(json)).toList();
  }

  Future<Venta> getVenta(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/ventas/$id'),
      headers: _headers,
    );
    
    _handleError(response);
    
    return Venta.fromJson(json.decode(response.body));
  }

  Future<List<Venta>> getVentasPorUsuario(int usuarioId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/ventas/usuario/$usuarioId'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Venta.fromJson(json)).toList();
  }

  Future<List<Venta>> getVentasPorEstado(String estado) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/ventas/estado/$estado'),
      headers: _headers,
    );
    
    _handleError(response);
    
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Venta.fromJson(json)).toList();
  }

  Future<Venta> createVenta(Venta venta) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/ventas'),
      headers: _headers,
      body: json.encode(venta.toJson()),
    );
    
    _handleError(response);
    
    return Venta.fromJson(json.decode(response.body));
  }

  Future<void> updateVenta(int id, Venta venta) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/ventas/$id'),
      headers: _headers,
      body: json.encode(venta.toJson()),
    );
    
    _handleError(response);
  }

  Future<void> updateEstadoVenta(int id, String estado) async {
    final response = await client.patch(
      Uri.parse('$_baseUrl/ventas/$id/estado'),
      headers: _headers,
      body: json.encode(estado),
    );
    
    _handleError(response);
  }

  Future<void> deleteVenta(int id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/ventas/$id'),
      headers: _headers,
    );
    
    _handleError(response);
  }

  // Cerrar el cliente HTTP
  void close() {
    client.close();
  }
}