import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/producto.dart'; // Asegúrate de tener la ruta correcta
import '../services/api_service.dart'; // Asegúrate de tener la ruta correcta

class AddProductScreen extends StatefulWidget {
  final int tiendaId; // Agregar tiendaId como parámetro
  final int categoriaProductoId; // Agregar categoriaProductoId como parámetro
  
  const AddProductScreen({
    Key? key,
    required this.tiendaId,
    required this.categoriaProductoId,
  }) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  final picker = ImagePicker();
  final ApiService _apiService = ApiService(); // Instancia del servicio API

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  bool _isLoading = false; // Para controlar el estado de carga

  // -------------------- SELECCIONAR IMAGEN --------------------

  /* 
  Esto es un comentario
  de múltiples líneas.
  Puede abarcar varias líneas.

  Future<void> _selectImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }
*/
  // -------------------- CONVERTIR IMAGEN A BASE64 --------------------
  String? _convertImageToBase64() {
    if (_image == null) return null;
    
    try {
      final bytes = _image!.readAsBytesSync();
      return base64Encode(bytes);
    } catch (e) {
      print("Error converting image to base64: $e");
      return null;
    }
  }

  // -------------------- GUARDAR PRODUCTO --------------------

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_image == null) {
       /* 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una imagen"),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }
 */
    setState(() {
      _isLoading = true;
    });

    try {
      // Convertir imagen a base64
      // Crear objeto Producto
      final nuevoProducto = Producto(
        nombre: nameCtrl.text.trim(),
        descripcion: descCtrl.text.trim(),
        precio: double.tryParse(priceCtrl.text.trim()) ?? 0,
        tiendaId: widget.tiendaId,
        categoriaProductoId: widget.categoriaProductoId,
        tienda: widget.tiendaId, // Si necesitas este campo
        categoriaProducto: '', // Dejar vacío o asignar según necesites
      );

      // Llamar a la API para crear el producto
      final productoCreado = await _apiService.createProducto(nuevoProducto);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Producto '${productoCreado.nombre}' creado exitosamente"),
          backgroundColor: Colors.green,
        ),
      );

      // Regresar el producto creado a la pantalla anterior
      Navigator.pop(context, productoCreado);

    } catch (e) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al crear el producto: ${e.toString()}"),
          backgroundColor: Colors.red,
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
  }

  @override
  void dispose() {
    // Limpiar controladores
    nameCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    _apiService.close(); // Cerrar conexión HTTP
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      appBar: AppBar(
        title: const Text("Agregar Producto", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // -------------------- IMAGEN --------------------
                     /* 
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_photo_alternate,
                                      size: 50, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text("Seleccionar Imagen"),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),
  */
                    // -------------------- NOMBRE --------------------
                    TextFormField(
                      controller: nameCtrl,
                      validator: (v) => v!.isEmpty ? "Ingresa un nombre" : null,
                      decoration: _fieldStyle("Nombre del producto"),
                    ),

                    const SizedBox(height: 20),

                    // -------------------- PRECIO --------------------
                    TextFormField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Ingresa un precio" : null,
                      decoration: _fieldStyle("Precio"),
                    ),

                    const SizedBox(height: 20),

                    // -------------------- DESCRIPCIÓN --------------------
                    TextFormField(
                      controller: descCtrl,
                      maxLines: 4,
                      decoration: _fieldStyle("Descripción (opcional)"),
                    ),

                    const SizedBox(height: 40),

                    // -------------------- BOTÓN GUARDAR --------------------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                                "Guardar Producto",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // -------------------- DECORACIÓN DE CAMPOS --------------------
  InputDecoration _fieldStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}