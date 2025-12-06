import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}


class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  final picker = ImagePicker();

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // -------------------- SELECCIONAR IMAGEN --------------------
  Future<void> _selectImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  // -------------------- GUARDAR PRODUCTO --------------------
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una imagen"),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    final product = {
      "name": nameCtrl.text.trim(),
      "price": double.tryParse(priceCtrl.text.trim()) ?? 0,
      "desc": descCtrl.text.trim(),
      "image": _image!.path,
    };

    Navigator.pop(context, product);
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // -------------------- IMAGEN --------------------
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
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
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
