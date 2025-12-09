class Tienda {
  int id;
  String nombre;
  String descripcion;
  int usuarioId;
  String usuario;

  Tienda({
    this.id = 0,
    required this.nombre,
    required this.descripcion,
    required this.usuarioId,
    this.usuario = '', String? imagenBase64,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) => Tienda(
        id: json['id'] ?? 0,
        nombre: json['nombre'] ?? '',
        descripcion: json['descripcion'] ?? '',
        usuarioId: json['usuarioId'] ?? 0,
        usuario: json['usuario'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'usuarioId': usuarioId,
        'usuario': usuario,
      };
}