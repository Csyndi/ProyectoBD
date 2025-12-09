import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/data/local_product_db.dart';

class EditProductScreen extends StatefulWidget {
  final int tiendaId;
  final int index;
  final Map<String, dynamic> product;

  const EditProductScreen({
    super.key,
    required this.tiendaId,
    required this.index,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nombreCtrl;
  late TextEditingController descCtrl;
  late TextEditingController precioCtrl;
  late TextEditingController imageCtrl;

  @override
  void initState() {
    super.initState();

    nombreCtrl = TextEditingController(text: widget.product['name']);
    descCtrl = TextEditingController(text: widget.product['description']);
    precioCtrl = TextEditingController(text: widget.product['price'].toString());
    imageCtrl = TextEditingController(text: widget.product['image']);
  }

 void guardarCambios() {
  final nombre = nombreCtrl.text.trim();
  final desc = descCtrl.text.trim();
  final precioText = precioCtrl.text.trim();

  if (nombre.isEmpty || precioText.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nombre y precio requeridos')),
    );
    return;
  }

  final precio = double.tryParse(precioText.replaceAll(',', '.')) ?? 0.0;
  if (precio <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Precio inválido')),
    );
    return;
  }

  final updatedProduct = {
    "id": widget.product["id"],
    "name": nombre,
    "description": desc,
    "price": precio,
    "image": imageCtrl.text.trim().isEmpty
        ? "https://via.placeholder.com/60"
        : imageCtrl.text.trim(),
  };

  LocalProductDB().updateProducto(widget.tiendaId, widget.index, updatedProduct);

  Navigator.pop(context, true);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: precioCtrl,
              decoration: const InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imageCtrl,
              decoration: const InputDecoration(labelText: "URL Imagen"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: guardarCambios,
              child: const Text("Guardar cambios"),
            )
          ],
        ),
      ),
    );
  }
}
