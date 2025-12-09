import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cakery_shop_ui/screen/home_screen.dart';
import 'package:flutter_cakery_shop_ui/services/auth_service.dart';

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
    "https://images.pexels.com/photos/2817452/pexels-photo-2817452.jpeg",
    "https://images.pexels.com/photos/533325/pexels-photo-533325.jpeg",
    "https://images.pexels.com/photos/135620/pexels-photo-135620.jpeg",
    "https://images.pexels.com/photos/1833586/pexels-photo-1833586.jpeg",
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
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // ============= LOGIN =============
  Future<void> _login() async {
    // Validación básica
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      setState(() => errorMessage = 'Por favor, completa todos los campos');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Llamar al servicio de autenticación
    final result = await authService.login(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    print('Login result: $result'); // Debug

    if (result['success'] == true) {
      // Login exitoso
      final userData = result['data'];
      print('Usuario autenticado: $userData'); // Debug

      // Obtener el ID del usuario de la respuesta
      // Ajusta según la estructura real de tu API
      final dynamic usuarioId = userData['id'] ?? 
                               userData['usuarioId'] ?? 
                               userData['userId'] ?? 
                               0;

      // Convertir a int si es necesario
      final int id = usuarioId is int ? usuarioId : int.tryParse(usuarioId.toString()) ?? 0;

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Bienvenido ${userData['nombre'] ?? ''}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar a la pantalla principal CON el ID del usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(usuarioId: id),
        ),
      );
    } else {
      // Mostrar error
      setState(() {
        errorMessage = result['message'] ?? 'Error al iniciar sesión';
      });

      // Mostrar snackbar con error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============= PRUEBA DE CONEXIÓN =============
  Future<void> _testConnection() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Intentar hacer login con credenciales de prueba
      print('Probando conexión con la API...');

      // Puedes cambiar estos valores por unos que existan en tu base de datos
      final testEmail = "test@example.com";
      final testPassword = "test123";

      final result = await authService.login(testEmail, testPassword);

      setState(() {
        isLoading = false;
        errorMessage =
            'Resultado prueba: ${result['success']} - ${result['message']}';
      });

      print('Resultado prueba: $result');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error de conexión: $e';
      });
    }
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
                        // Botón de prueba (solo para desarrollo)
                        if (errorMessage.contains('prueba') ||
                            errorMessage.contains('conexión'))
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: OutlinedButton(
                              onPressed: _testConnection,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.yellow,
                                side: const BorderSide(color: Colors.yellow),
                              ),
                              child: const Text('Probar Conexión API'),
                            ),
                          ),

                        if (errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: errorMessage.contains('¡Bienvenido')
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  errorMessage.contains('¡Bienvenido')
                                      ? Icons.check_circle
                                      : Icons.error_outline,
                                  color: errorMessage.contains('¡Bienvenido')
                                      ? Colors.green.shade300
                                      : Colors.red.shade300,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color:
                                          errorMessage.contains('¡Bienvenido')
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
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
                          keyboardType: TextInputType.emailAddress,
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: isLoading
                                  ? Colors.grey
                                  : Colors.blueAccent.withOpacity(0.9),
                              elevation: 5,
                              shadowColor: Colors.blueAccent.withOpacity(0.5),
                            ),
                            onPressed: isLoading ? null : _login,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.login, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        "Iniciar sesión",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // OLVIDÉ MI CONTRASEÑA
                        TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función en desarrollo'),
                              ),
                            );
                          },
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // CREAR CUENTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿No tienes cuenta? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text(
                                "Regístrate",
                                style: TextStyle(
                                  color: const Color(0xFFFF66AA),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CRÉDITOS
                  Column(
                    children: [
                      Text(
                        "Por: Cindy Saenz y Diego Rubio",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "API: http://localhost:7084",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
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
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}