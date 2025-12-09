class Venta {
  int id;
  int usuarioId;
  DateTime fechaVenta;
  double total;
  String estado;
  String usuario;
  String detalleVentas;

  Venta({
    this.id = 0,
    required this.usuarioId,
    DateTime? fechaVenta,
    required this.total,
    this.estado = 'Pendiente',
    this.usuario = '',
    this.detalleVentas = '',
  }) : fechaVenta = fechaVenta ?? DateTime.now();

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        id: json['id'] ?? 0,
        usuarioId: json['usuarioId'] ?? 0,
        fechaVenta: json['fechaVenta'] != null
            ? DateTime.parse(json['fechaVenta'])
            : DateTime.now(),
        total: (json['total'] ?? 0).toDouble(),
        estado: json['estado'] ?? 'Pendiente',
        usuario: json['usuario'] ?? '',
        detalleVentas: json['detalleVentas'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'fechaVenta': fechaVenta.toIso8601String(),
        'total': total,
        'estado': estado,
        'usuario': usuario,
        'detalleVentas': detalleVentas,
      };
}