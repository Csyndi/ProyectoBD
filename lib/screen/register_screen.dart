import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cakery_shop_ui/screen/services/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String errorMessage = '';

  Future<void> _register() async {
    // Validaciones
    if (nombreCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        confirmPassCtrl.text.isEmpty) {
      setState(() {
        errorMessage = 'Todos los campos son obligatorios';
      });
      return;
    }

    if (passCtrl.text != confirmPassCtrl.text) {
      setState(() {
        errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final result = await authService.register(
      emailCtrl.text,
      passCtrl.text,
      nombreCtrl.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Cuenta creada exitosamente!',
            style: TextStyle(color: Colors.green.shade100),
          ),
          backgroundColor: Colors.green.shade800,
        ),
      );
      
      // Volver al login después de un momento
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        errorMessage = result['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Fondo similar al login
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1a1a2e),
                    Color(0xFF16213e),
                    Color(0xFF0f3460),
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título
                  Text(
                    "Crear cuenta",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.95),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    "Únete a nuestra comunidad",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // Tarjeta de formulario
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade300, size: 20),
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
                        
                        if (errorMessage.isNotEmpty) const SizedBox(height: 15),

                        _buildTextField(
                          controller: nombreCtrl,
                          label: "Nombre completo",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 15),
                        
                        _buildTextField(
                          controller: emailCtrl,
                          label: "Correo electrónico",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        
                        _buildTextField(
                          controller: passCtrl,
                          label: "Contraseña",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isPasswordVisible: isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() => isPasswordVisible = !isPasswordVisible);
                          },
                        ),
                        const SizedBox(height: 15),
                        
                        _buildTextField(
                          controller: confirmPassCtrl,
                          label: "Confirmar contraseña",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isPasswordVisible: isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible);
                          },
                        ),
                        
                        const SizedBox(height: 30),

                        // Botón de registro
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ).copyWith(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                return null;
                              }),
                            ),
                            onPressed: isLoading ? null : _register,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : ShaderMask(
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFFAA4CFF),
                                          Color(0xFF33BFFF),
                                          Color(0xFFFF66AA),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      "Crear cuenta",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Enlace para volver al login
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: RichText(
                              text: TextSpan(
                                text: '¿Ya tienes cuenta? ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Iniciar sesión',
                                    style: TextStyle(
                                      color: const Color(0xFFFFB933),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: const Color(0xFFFFB933),
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.8),
        ),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.9)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF33BFFF)),
        ),
      ),
    );
  }
}