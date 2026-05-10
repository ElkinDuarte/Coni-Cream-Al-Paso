import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _documentController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ValueNotifier por campo: solo reconstruye ESE campo, no toda la pantalla
  final _passwordVisible = ValueNotifier<bool>(false);
  final _confirmPasswordVisible = ValueNotifier<bool>(false);

  static const Color _pink = Color(0xFFE91E8C);

  @override
  void dispose() {
    _documentController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final doc = _documentController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (doc.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        pass.isEmpty ||
        confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: _pink,
        ),
      );
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: _pink,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Registro exitoso! Bienvenido $name'),
        backgroundColor: _pink,
      ),
    );

    Navigator.of(context).pop();
  }

  // Campo simple sin visibilidad (no necesita ValueNotifier)
  Widget _buildSimpleField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String hintText = '',
    String? prefixText,
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

  // Campo de contraseña: ValueListenableBuilder → solo este widget se reconstruye
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

                // ── MIDDLE: 5 campos ──
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
                      label: 'Nombre Usuario',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      hintText: 'Juan Perez',
                    ),
                    const SizedBox(height: 16),
                    _buildSimpleField(
                      label: 'Telefono',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: '999 9999999',
                      prefixText: '+57   ',
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
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
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
}
