import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const AlPasoApp());
}

class AlPasoApp extends StatelessWidget {
  const AlPasoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlPaso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _documentController = TextEditingController();
  final _passwordController = TextEditingController();

  // ValueNotifier: solo reconstruye el IconButton, no toda la pantalla
  final _passwordVisible = ValueNotifier<bool>(false);

  static const Color _pink = Color(0xFFE91E8C);

  @override
  void dispose() {
    _documentController.dispose();
    _passwordController.dispose();
    _passwordVisible.dispose();
    super.dispose();
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
                // ── TOP: Logo + nombre ──
                Column(
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          // Cachea la imagen al tamaño de render → menos trabajo GPU
                          cacheWidth: 380,
                          cacheHeight: 380,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'AlPaso',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // ── MIDDLE: Campos ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Numero Documento',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _documentController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: '9999999999',
                        hintStyle: TextStyle(color: Colors.black38),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _pink, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ValueListenableBuilder → solo reconstruye este TextField
                    ValueListenableBuilder<bool>(
                      valueListenable: _passwordVisible,
                      builder: (_, visible, __) {
                        return TextField(
                          controller: _passwordController,
                          obscureText: !visible,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: '••••••••••',
                            hintStyle:
                                const TextStyle(color: Colors.black38),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: _pink, width: 2),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            suffixIcon: IconButton(
                              icon: Icon(
                                visible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.black45,
                              ),
                              onPressed: () =>
                                  _passwordVisible.value = !visible,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          '¿Olvidó la contraseña?',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
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
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tiene una cuenta? ',
                          style: TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            // Transición de 180ms en lugar de 300ms por defecto
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const RegisterScreen(),
                              transitionDuration:
                                  const Duration(milliseconds: 180),
                              transitionsBuilder: (_, anim, __, child) =>
                                  FadeTransition(
                                      opacity: anim, child: child),
                            ),
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 14,
                              color: _pink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Todos los derechos reservados',
                      style:
                          TextStyle(fontSize: 12, color: Colors.black38),
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

  void _handleLogin() {
    final doc = _documentController.text.trim();
    final pass = _passwordController.text.trim();

    if (doc.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa tu documento y contraseña'),
          backgroundColor: _pink,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bienvenido $doc'),
        backgroundColor: _pink,
      ),
    );
  }
}
