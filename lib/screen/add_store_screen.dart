import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // Para base64
import '../models/tienda.dart'; // Importar el modelo Tienda
import '../services/api_service.dart'; // Importar ApiService
import '../models/usuario.dart'; // Si necesitas el usuario actual

class AddStoreScreen extends StatefulWidget {
  final int usuarioId; // ID del usuario que crea la tienda
  
  const AddStoreScreen({
    Key? key,
    required this.usuarioId,
  }) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  final picker = ImagePicker();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  // --------------------------------------------------------------------------

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  // --------------------------------------------------------------------------

  String? _convertImageToBase64() {
    if (_imageFile == null) return null;
    
    try {
      final bytes = _imageFile!.readAsBytesSync();
      return base64Encode(bytes);
    } catch (e) {
      print("Error converting image to base64: $e");
      return null;
    }
  }

  // --------------------------------------------------------------------------

 Future<void> _saveStore() async {
  if (!_formKey.currentState!.validate()) return;

  // REMOVER esta validación que hace obligatoria la imagen
  // if (_imageFile == null) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text("Por favor selecciona una imagen"),
  //       backgroundColor: Colors.deepOrange,
  //     ),
  //   );
  //   return;
  // }

  setState(() {
    _isLoading = true;
  });

  try {
    // Convertir imagen a base64 solo si existe
    final String? imagenBase64 = _imageFile != null 
        ? _convertImageToBase64() 
        : null;
    
    // Quitar la validación de error si la imagen es null
    // if (imagenBase64 == null) {
    //   throw Exception("Error al procesar la imagen");
    // }

    // Crear objeto Tienda - la imagen puede ser null
    final nuevaTienda = Tienda(
      nombre: _nameController.text.trim(),
      descripcion: _descController.text.trim(),
      usuarioId: widget.usuarioId,
      // Pasar imagenBase64 solo si existe, sino null
      imagenBase64: imagenBase64,
    );

    // Llamar a la API para crear la tienda
    final tiendaCreada = await _apiService.createTienda(nuevaTienda);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tienda '${tiendaCreada.nombre}' creada exitosamente"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Regresar la tienda creada a la pantalla anterior
    Navigator.pop(context, tiendaCreada);

  } catch (e) {
    // Mostrar error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error al crear la tienda: ${e.toString()}"),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  // --------------------------------------------------------------------------

  void _cancelar() {
    Navigator.pop(context);
  }

  // --------------------------------------------------------------------------

  @override
  void dispose() {
    // Limpiar controladores
    _nameController.dispose();
    _descController.dispose();
    _ubicacionController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _apiService.close(); // Cerrar conexión HTTP
    super.dispose();
  }

  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          "Agregar Tienda",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _isLoading ? null : _cancelar,
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Creando tienda...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ------------------- PORTADA -------------------
                    _buildImageSection(),

                    const SizedBox(height: 25),

                    // ------------------- NOMBRE -------------------
                    _buildLabel("Nombre de la tienda"),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _nameController,
                      validator: (v) => v!.isEmpty ? "Escribe un nombre" : null,
                      decoration: _inputDecoration("Ej. La Esquinita"),
                    ),

                    const SizedBox(height: 20),

                    // ------------------- DESCRIPCIÓN -------------------
                    _buildLabel("Descripción"),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? "Escribe una descripción" : null,
                      decoration: _inputDecoration("Describe la tienda..."),
                    ),

                    const SizedBox(height: 20),

                    // ------------------- UBICACIÓN -------------------
                    _buildLabel("Ubicación"),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _ubicacionController,
                      decoration: _inputDecoration("Dirección de la tienda"),
                    ),

                    const SizedBox(height: 20),

                    // ------------------- TELÉFONO -------------------
                    _buildLabel("Teléfono"),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration("Número de contacto"),
                    ),

                    const SizedBox(height: 20),

                    // ------------------- EMAIL -------------------
                    _buildLabel("Email"),
                    const SizedBox(height: 6),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration("Correo electrónico"),
                    ),

                    const SizedBox(height: 35),

                    // ------------------- BOTONES -------------------
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  // --------------------------------------------------------------------------

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _imageFile == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_photo_alternate,
                    size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  "Agregar imagen de portada",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  "(Recomendado: 800x400 px)",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  // --------------------------------------------------------------------------

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // --------------------------------------------------------------------------

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Botón Cancelar
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : _cancelar,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        
        const SizedBox(width: 15),
        
        // Botón Guardar
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveStore,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "Guardar Tienda",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}