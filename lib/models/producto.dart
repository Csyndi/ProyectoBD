class Producto {
  int id;
  String nombre;
  String descripcion;
  double precio;
  String imagenUrl;
  int tiendaId;
  int categoriaProductoId;
  int tienda;
  String categoriaProducto;

  Producto({
    this.id = 0,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    this.imagenUrl = '',
    required this.tiendaId,
    required this.categoriaProductoId,
    this.tienda = 0,
    this.categoriaProducto = '',
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json['id'] ?? 0,
        nombre: json['nombre'] ?? '',
        descripcion: json['descripcion'] ?? '',
        precio: (json['precio'] ?? 0).toDouble(),
        imagenUrl: json['imagenUrl'] ?? '',
        tiendaId: json['tiendaId'] ?? 0,
        categoriaProductoId: json['categoriaProductoId'] ?? 0,
        tienda: json['tienda'] ?? 0,
        categoriaProducto: json['categoriaProducto'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagenUrl': imagenUrl,
        'tiendaId': tiendaId,
        'categoriaProductoId': categoriaProductoId,
        'tienda': tienda,
        'categoriaProducto': categoriaProducto,
      };
}