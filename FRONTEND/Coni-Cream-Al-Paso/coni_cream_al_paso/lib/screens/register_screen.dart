import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _documentController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ValueNotifier por campo: solo reconstruye ESE campo, no toda la pantalla
  final _passwordVisible = ValueNotifier<bool>(false);
  final _confirmPasswordVisible = ValueNotifier<bool>(false);

  bool _isLoading = false;

  static const Color _pink = Color(0xFFE91E8C);

  @override
  void dispose() {
    _documentController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final doc = _documentController.text.trim();
    final name = _nameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    // ── Validaciones locales ──
    if (doc.isEmpty || name.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showSnack('Por favor completa los campos obligatorios');
      return;
    }

    if (doc.length > 11) {
      _showSnack('El documento no puede superar 11 dígitos');
      return;
    }

    if (pass.length < 6) {
      _showSnack('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (pass != confirm) {
      _showSnack('Las contraseñas no coinciden');
      return;
    }

    // ── Mostrar spinner ──
    setState(() => _isLoading = true);

    // ── Llamada al backend ──
    final result = await AuthService.register(
      numeroDocumento: doc,
      nombre: name,
      primerApellido: lastName.isEmpty ? null : lastName,
      clave: pass,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.ok) {
      _showSnack('¡Registro exitoso! Bienvenido $name 🎉');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.of(context).pop();
    } else {
      _showSnack(result.mensaje);
    }
  }

  // Campo simple sin visibilidad
  Widget _buildSimpleField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String hintText = '',
    String? prefixText,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (!required)
              const Text(
                ' (opcional)',
                style: TextStyle(fontSize: 12, color: Colors.black38),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 17, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 17),
            prefixText: prefixText,
            prefixStyle: const TextStyle(fontSize: 17, color: Colors.black87),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: _pink, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }

  // Campo de contraseña con toggle visibilidad
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required ValueNotifier<bool> visibleNotifier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<bool>(
          valueListenable: visibleNotifier,
          builder: (_, visible, _) {
            return TextField(
              controller: controller,
              obscureText: !visible,
              style: const TextStyle(fontSize: 17, color: Colors.black87),
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 17),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: _pink, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: IconButton(
                  icon: Icon(
                    visible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black45,
                    size: 22,
                  ),
                  onPressed: () => visibleNotifier.value = !visible,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final availH = mq.size.height - mq.padding.top - mq.padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: availH),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── TOP: Logo + título ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            cacheWidth: 240,
                            cacheHeight: 240,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ingresa los datos personales para continuar',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),

                // ── MIDDLE: Campos ──
                Column(
                  children: [
                    _buildSimpleField(
                      label: 'Numero Documento',
                      controller: _documentController,
                      keyboardType: TextInputType.number,
                      hintText: '9999999999',
                    ),
                    const SizedBox(height: 16),
                    _buildSimpleField(
                      label: 'Nombre',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      hintText: 'Juan',
                    ),
                    const SizedBox(height: 16),
                    _buildSimpleField(
                      label: 'Primer Apellido',
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      hintText: 'Pérez',
                      required: false,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: 'Contraseña',
                      controller: _passwordController,
                      visibleNotifier: _passwordVisible,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      label: 'Confirmar Contraseña',
                      controller: _confirmPasswordController,
                      visibleNotifier: _confirmPasswordVisible,
                    ),
                  ],
                ),

                // ── BOTTOM: Botones + copyright ──
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _pink.withAlpha(153),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Registrar',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: _pink,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Volver',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Todos los derechos reservados',
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: _pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
