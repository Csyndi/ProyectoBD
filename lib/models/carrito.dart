class Carrito {
  int id;
  int usuarioId;
  DateTime fechaCreacion;
  String usuario;
  String carritoDetalles;

  Carrito({
    this.id = 0,
    required this.usuarioId,
    DateTime? fechaCreacion,
    this.usuario = '',
    this.carritoDetalles = '',
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  factory Carrito.fromJson(Map<String, dynamic> json) => Carrito(
        id: json['id'] ?? 0,
        usuarioId: json['usuarioId'] ?? 0,
        fechaCreacion: json['fechaCreacion'] != null
            ? DateTime.parse(json['fechaCreacion'])
            : DateTime.now(),
        usuario: json['usuario'] ?? '',
        carritoDetalles: json['carritoDetalles'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'usuario': usuario,
        'carritoDetalles': carritoDetalles,
      };
}