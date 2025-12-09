import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_cakery_shop_ui/screen/services/tienda_service.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final TiendaService _tiendaService = TiendaService();

  File? _imageFile;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  // Lista de categorías (ajusta según tu API)
final List<Map<String, dynamic>> _categorias = [
  {'id': 1, 'nombre': 'Abarrotes'},
  {'id': 2, 'nombre': 'Ferretería'},
  {'id': 3, 'nombre': 'Pastelería'},
  {'id': 4, 'nombre': 'Restaurante'},
  {'id': 5, 'nombre': 'Ropa'},
  {'id': 6, 'nombre': 'Electrónica'},
  {'id': 7, 'nombre': 'General'},
];

  int? _selectedCategoriaId;

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

// En AddStoreScreen.dart - Modifica _saveStore
Future<void> _saveStore() async {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedCategoriaId == null || _selectedCategoriaId! <= 0) {
    setState(() {
      _errorMessage = 'Por favor selecciona una categoría válida';
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  try {
    // ✅ TEMPORAL: No enviar imagen en web, solo datos básicos
    // La imagen se manejará después
    print('=== MODO WEB DETECTADO ===');
    print('Imagen será omitida temporalmente para pruebas');
    
    final result = await _tiendaService.crearTienda(
      nombre: _nameController.text.trim(),
      descripcion: _descController.text.trim(),
      direccion: _direccionController.text.trim(),
      telefono: _telefonoController.text.trim(),
      categoriaId: _selectedCategoriaId!,
      imagen: null, // ✅ TEMPORALMENTE NULL
    );

    setState(() {
      _isLoading = false;
    });

    print('=== RESPUESTA ===');
    print('Success: ${result['success']}');
    print('Message: ${result['message']}');
    print('Status: ${result['statusCode']}');

    if (result['success'] == true) {
      _showSuccessDialog(result['data']);
    } else {
      String errorMsg = result['message'] ?? 'Error al crear la tienda';
      
      // Manejo específico de error 405
      if (result['statusCode'] == 405) {
        errorMsg = 'Error 405: El endpoint no acepta POST. Verifica:';
        errorMsg += '\n1. Que el endpoint /api/Tiendas exista';
        errorMsg += '\n2. Que acepte método POST';
        errorMsg += '\n3. Que acepte Content-Type: application/json';
      } else if (result['statusCode'] == 400) {
        errorMsg = 'Error de validación: ' + errorMsg;
      }
      
      setState(() {
        _errorMessage = errorMsg;
      });
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Error: $e';
    });
  }
}

  void _showSuccessDialog(Map<String, dynamic> tienda) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 10),
            Text('¡Tienda creada!'),
          ],
        ),
        content: Text(
          'La tienda "${tienda['name']}" ha sido creada exitosamente.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(true); // Regresar con éxito
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

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
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mensaje de error
                  if (_errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ------------------- PORTADA -------------------
                  GestureDetector(
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
                                  "Agregar imagen de portada (Opcional)",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ------------------- NOMBRE -------------------
                  const Text(
                    "Nombre de la tienda *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _nameController,
                    validator: (v) =>
                        v!.isEmpty ? "El nombre es obligatorio" : null,
                    decoration: _inputDecoration("Ej. La Esquinita"),
                  ),

                  const SizedBox(height: 20),

                  // ------------------- DESCRIPCIÓN -------------------
                  const Text(
                    "Descripción *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    validator: (v) =>
                        v!.isEmpty ? "La descripción es obligatoria" : null,
                    decoration: _inputDecoration("Describe tu tienda..."),
                  ),

                  const SizedBox(height: 20),

                  // ------------------- DIRECCIÓN -------------------
                  const Text(
                    "Dirección *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _direccionController,
                    validator: (v) =>
                        v!.isEmpty ? "La dirección es obligatoria" : null,
                    decoration: _inputDecoration("Calle, número, colonia..."),
                  ),

                  const SizedBox(height: 20),

                  // ------------------- TELÉFONO -------------------
                  const Text(
                    "Teléfono *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty
                        ? "El teléfono es obligatorio"
                        : v.length < 10
                            ? "Ingresa un teléfono válido"
                            : null,
                    decoration: _inputDecoration("10 dígitos"),
                  ),

                  const SizedBox(height: 20),

                  // ------------------- CATEGORÍA -------------------
                  const Text(
                    "Categoría *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedCategoriaId,
                        hint: const Text('Selecciona una categoría'),
                        isExpanded: true,
                        items: _categorias.map((categoria) {
                          return DropdownMenuItem<int>(
                            value: categoria['id'],
                            child: Text(categoria['nombre']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoriaId = value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ------------------- BOTÓN GUARDAR -------------------
                  SizedBox(
                    width: double.infinity,
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
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Guardar Tienda",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.deepOrange),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}