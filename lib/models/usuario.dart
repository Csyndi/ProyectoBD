class Usuario {
  int id;
  String nombre;
  String email;
  String contrasena;
  String rol;
  DateTime fechaCreacion;
  bool activo;

  Usuario({
    this.id = 0,
    required this.nombre,
    required this.email,
    required this.contrasena,
    this.rol = 'Cliente',
    DateTime? fechaCreacion,
    this.activo = true,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] ?? 0,
        nombre: json['nombre'] ?? '',
        email: json['email'] ?? '',
        contrasena: json['contrasena'] ?? '',
        rol: json['rol'] ?? 'Cliente',
        fechaCreacion: json['fechaCreacion'] != null
            ? DateTime.parse(json['fechaCreacion'])
            : DateTime.now(),
        activo: json['activo'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'contrasena': contrasena,
        'rol': rol,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'activo': activo,
      };
}