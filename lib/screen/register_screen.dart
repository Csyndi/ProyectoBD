import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cakery_shop_ui/screen/login_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();

  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
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
        errorMessage = 'Los campos obligatorios deben ser completados';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailCtrl.text)) {
      setState(() {
        errorMessage = 'Por favor, ingresa un email válido';
      });
      return;
    }

    if (passCtrl.text.length < 6) {
      setState(() {
        errorMessage = 'La contraseña debe tener al menos 6 caracteres';
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

    try {
      print('=== INICIANDO REGISTRO ===');
      print('Email: ${emailCtrl.text}');
      print('Nombre: ${nombreCtrl.text}');

      final result = await authService.register(
        emailCtrl.text.trim(),
        passCtrl.text,
        nombreCtrl.text.trim(),
      );

      print('=== RESPUESTA DEL SERVIDOR ===');
      print('Success: ${result['success']}');
      print('Message: ${result['message']}');
      print('Status: ${result['statusCode']}');

      if (result.containsKey('errorDetails')) {
        print('Error details: ${result['errorDetails']}');
      }

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        _showSuccessDialog();
      } else {
        String errorMsg = result['message'] ?? 'Error en el registro';

        // Si es error 500, muestra mensaje específico
        if (result['statusCode'] == 500) {
          errorMsg = 'Error interno del servidor. Contacta al administrador.';
        }

        setState(() {
          errorMessage = errorMsg;
        });
      }
    } catch (e) {
      print('=== EXCEPCIÓN CAPTURADA ===');
      print('Error: $e');

      setState(() {
        isLoading = false;
        errorMessage = 'Error de conexión: $e';
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade400, size: 30),
            const SizedBox(width: 10),
            Text(
              '¡Registro exitoso!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Tu cuenta ha sido creada correctamente. Ahora puedes iniciar sesión.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Cierra el diálogo
              Navigator.of(context).pop();

              // Navega de regreso al login, reemplazando la pantalla actual
              // Esto evita que el usuario pueda volver atrás al registro
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      LoginScreen(), // Asegúrate de importar tu LoginScreen
                ),
              );
            },
            child: const Text(
              'Ir al login',
              style: TextStyle(color: Color(0xFF33BFFF)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    emailCtrl.dispose();
    telefonoCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          // Fondo
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
                // Logo/Ícono
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Icon(
                    Icons.person_add_alt_1,
                    size: 40,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 8),

                Text(
                  "Únete a nuestra comunidad",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 30),

                // Tarjeta de formulario
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    if (errorMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade300,
                              size: 20,
                            ),
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

                    // Campos del formulario
                    _buildTextField(
                      controller: nombreCtrl,
                      label: "Nombre completo *",
                      icon: Icons.person_outline,
                      hintText: "Ej: Juan Pérez",
                    ),

                    const SizedBox(height: 12),

                    // Campo opcional para apellido (si tu API lo necesita)
                    // _buildTextField(
                    //   controller: apellidoCtrl,
                    //   label: "Apellido",
                    //   icon: Icons.person_outline,
                    //   hintText: "Ej: Pérez",
                    //   isRequired: false,
                    // ),

                    // const SizedBox(height: 12),

                    _buildTextField(
                      controller: emailCtrl,
                      label: "Correo electrónico *",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "ejemplo@correo.com",
                    ),

                    const SizedBox(height: 12),

                    // Campo opcional para teléfono (si tu API lo necesita)
                    // _buildTextField(
                    //   controller: telefonoCtrl,
                    //   label: "Teléfono",
                    //   icon: Icons.phone_outlined,
                    //   keyboardType: TextInputType.phone,
                    //   hintText: "123456789",
                    //   isRequired: false,
                    // ),

                    // const SizedBox(height: 12),

                    _buildTextField(
                      controller: passCtrl,
                      label: "Contraseña *",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: isPasswordVisible,
                      hintText: "Mínimo 6 caracteres",
                      onToggleVisibility: () {
                        setState(() => isPasswordVisible = !isPasswordVisible);
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: confirmPassCtrl,
                      label: "Confirmar contraseña *",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: isConfirmPasswordVisible,
                      hintText: "Repite tu contraseña",
                      onToggleVisibility: () {
                        setState(() => isConfirmPasswordVisible =
                            !isConfirmPasswordVisible);
                      },
                    ),

                    const SizedBox(height: 25),

                    // Botón de registro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: isLoading ? null : _register,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isLoading
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFFAA4CFF),
                                      Color(0xFF33BFFF),
                                      Color(0xFFFF66AA),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
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
                    ),

                    const SizedBox(height: 20),

                    // Información adicional
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade300,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Los campos marcados con * son obligatorios',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Enlace para volver al login
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '¿Ya tienes una cuenta? ',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 15,
                            ),
                          ),
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              splashColor:
                                  const Color(0xFFFFB933).withOpacity(0.3),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    color: const Color(0xFFFFB933),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFFFFB933),
                                    decorationThickness: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ))
        ]));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String hintText = '',
    bool isPassword = false,
    bool isRequired = true,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            keyboardType: keyboardType,
            enabled: !isLoading,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
              prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF33BFFF),
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
