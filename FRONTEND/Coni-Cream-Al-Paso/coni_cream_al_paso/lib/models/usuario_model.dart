/// Modelo que representa al usuario autenticado.
/// Mapea la respuesta JSON del endpoint POST /auth/login.
class UsuarioModel {
  final String numeroDocumento;
  final String nombre;
  final String? primerApellido;
  final int rol;
  final String nombreRol;

  const UsuarioModel({
    required this.numeroDocumento,
    required this.nombre,
    this.primerApellido,
    required this.rol,
    required this.nombreRol,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      numeroDocumento: json['numero_documento'] as String,
      nombre: json['nombre'] as String,
      primerApellido: json['primer_apellido'] as String?,
      rol: json['rol'] as int,
      nombreRol: json['nombre_rol'] as String,
    );
  }

  /// Nombre completo para mostrar en la UI
  String get nombreCompleto {
    if (primerApellido != null && primerApellido!.isNotEmpty) {
      return '$nombre $primerApellido';
    }
    return nombre;
  }

  /// ¿Es administrador? (rol == 1)
  bool get esAdmin => rol == 1;
}
