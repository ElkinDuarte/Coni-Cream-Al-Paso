import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';

/// Resultado tipado que devuelve cada método del servicio.
/// [ok]      → true si la operación fue exitosa
/// [mensaje] → mensaje del servidor (éxito o error)
/// [data]    → payload opcional (ej: UsuarioModel en login)
class AuthResult<T> {
  final bool ok;
  final String mensaje;
  final T? data;

  const AuthResult({required this.ok, required this.mensaje, this.data});
}

/// Capa de acceso al backend de autenticación.
/// Centraliza todas las llamadas HTTP al módulo /auth.
class AuthService {
  // ── Configuración ───────────────────────────────────────────────────────────
  // En Android Emulator: 10.0.2.2 apunta al localhost del PC host.
  // En dispositivo físico en la misma red: usar la IP local del PC (ej: 192.168.1.X).
  // En iOS Simulator: localhost funciona directamente.
  static const String _baseUrl = 'http://192.168.100.10:3000';

  static const _headers = {'Content-Type': 'application/json'};
  static const String _tokenKey = 'auth_token';
  static const String _usuarioKey = 'auth_usuario';

  // ── Login ───────────────────────────────────────────────────────────────────
  /// Autentica al usuario con su número de documento y clave.
  /// Si el login es exitoso guarda el JWT en SharedPreferences.
  static Future<AuthResult<UsuarioModel>> login({
    required String numeroDocumento,
    required String clave,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/auth/login');
      final body = jsonEncode({
        'numero_documento': numeroDocumento,
        'clave': clave,
      });

      final response = await http
          .post(uri, headers: _headers, body: body)
          .timeout(const Duration(seconds: 10));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && json['ok'] == true) {
        final token = json['token'] as String;
        final usuario = UsuarioModel.fromJson(
          json['usuario'] as Map<String, dynamic>,
        );

        // Persistir token y datos del usuario
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_usuarioKey, jsonEncode(json['usuario']));

        return AuthResult(
          ok: true,
          mensaje: json['mensaje'] as String,
          data: usuario,
        );
      } else {
        return AuthResult(
          ok: false,
          mensaje: json['mensaje'] as String? ?? 'Error desconocido',
        );
      }
    } on Exception catch (e) {
      return AuthResult(ok: false, mensaje: _friendlyError(e.toString()));
    }
  }

  // ── Register ────────────────────────────────────────────────────────────────
  /// Registra un nuevo comerciante. Requiere token de Administrador guardado.
  static Future<AuthResult<void>> register({
    required String numeroDocumento,
    required String nombre,
    String? primerApellido,
    required String clave,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        return const AuthResult(
          ok: false,
          mensaje: 'No hay sesión activa. Inicia sesión primero.',
        );
      }

      final uri = Uri.parse('$_baseUrl/auth/register');
      final body = jsonEncode({
        'numero_documento': numeroDocumento,
        'nombre': nombre,
        if (primerApellido != null && primerApellido.isNotEmpty)
          'primer_apellido': primerApellido,
        'clave': clave,
      });

      final response = await http
          .post(
            uri,
            headers: {..._headers, 'Authorization': 'Bearer $token'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      return AuthResult(
        ok: json['ok'] == true,
        mensaje: json['mensaje'] as String? ?? 'Error desconocido',
      );
    } on Exception catch (e) {
      return AuthResult(ok: false, mensaje: _friendlyError(e.toString()));
    }
  }

  // ── Token & Sesión ──────────────────────────────────────────────────────────
  /// Recupera el JWT almacenado localmente. Retorna null si no hay sesión.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Recupera el usuario almacenado localmente.
  static Future<UsuarioModel?> getUsuarioLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usuarioKey);
    if (raw == null) return null;
    return UsuarioModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Verifica si hay una sesión activa (token guardado).
  static Future<bool> haySesion() async {
    return (await getToken()) != null;
  }

  /// Cierra la sesión eliminando el token y los datos del usuario.
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usuarioKey);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  /// Convierte excepciones de red en mensajes amigables para el usuario.
  static String _friendlyError(String raw) {
    if (raw.contains('SocketException') ||
        raw.contains('Connection refused') ||
        raw.contains('Failed host lookup')) {
      return 'No se pudo conectar al servidor. Verifica tu conexión o que el backend esté corriendo.';
    }
    if (raw.contains('TimeoutException')) {
      return 'El servidor tardó demasiado en responder. Intenta de nuevo.';
    }
    return 'Error inesperado. Intenta de nuevo.';
  }
}
