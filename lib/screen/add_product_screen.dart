import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/data/local_product_db.dart';

class AddProductScreen extends StatefulWidget {
  final int tiendaId;
  final String tiendaNombre;

  const AddProductScreen({
    Key? key,
    required this.tiendaId,
    required this.tiendaNombre,
  }) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar producto a ${widget.tiendaNombre}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                    value!.isEmpty ? "El nombre es obligatorio" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Precio"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Ingresa un precio" : null,
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: "URL de la imagen (opcional)",
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    LocalProductDB().addProducto(widget.tiendaId, {
                      "id": DateTime.now().millisecondsSinceEpoch,
                      "name": nameController.text,
                      "description": descriptionController.text,
                      "price": double.tryParse(priceController.text) ?? 0.0,
                      "image": imageController.text.isEmpty
                          ? "https://via.placeholder.com/60"
                          : imageController.text,
                    });

                    Navigator.pop(context, true);
                  }
                },
                child: const Text("Guardar Producto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
