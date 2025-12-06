import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;
  String errorMessage = '';

  final AuthService authService = AuthService();

  // ===== Imagenes de fondo animadas =====
  final List<String> bgImages = [
    "https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg",
    "https://images.pexels.com/photos/4481326/pexels-photo-4481326.jpeg",
    "https://images.pexels.com/photos/533325/pexels-photo-533325.jpeg",
   
  ];

  int currentImageIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Cambiar imagen cada 4 segundos
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        currentImageIndex =
            (currentImageIndex + 1) % bgImages.length; // Ciclo infinito
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // ============= LOGIN =============
  Future<void> _login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      setState(() => errorMessage = 'Por favor, completa todos los campos');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final result = await authService.login(emailCtrl.text, passCtrl.text);

    setState(() => isLoading = false);

    if (result['success'] == true) {
      _saveToken(result['data']['token']);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        errorMessage = result['message'] ?? 'Error desconocido';
      });
    }
  }

  void _saveToken(String token) {
    print('Token guardado: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== FONDO ANIMADO =====
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: Container(
              key: ValueKey<int>(currentImageIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(bgImages[currentImageIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Oscurecido
          Container(color: Colors.black.withOpacity(0.55)),

          // ===== CONTENIDO =====
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // FRASE
                  Text(
                    "Donde cada tienda vive,\n y cada compra inspira.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.95),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // TARJETA LOGIN
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade300, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color: Colors.red.shade100,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),

                        _inputField(
                          controller: emailCtrl,
                          label: "Correo electrónico",
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 20),

                        _inputField(
                          controller: passCtrl,
                          label: "Contraseña",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 30),

                        // BOTÓN LOGIN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: isLoading ? null : _login,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    "Iniciar sesión",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // CREAR CUENTA — más visible
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Crear cuenta",
                            style: TextStyle(
                              color: Color(0xFFFF66AA),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CRÉDITOS
                  Text(
                    "Por: Cindy Saenz y Diego Rubio",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET CAMPO DE TEXTO =================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.9)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
