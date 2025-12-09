import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/models/producto.dart';

// En product_detail_screen.dart
class ProductDetailScreen extends StatelessWidget {
  final Producto product; // Cambiar de Map<String, dynamic> a Producto

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Usar product.nombre, product.precio, etc.
    return Scaffold(
      appBar: AppBar(
        title: Text(product.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imagenUrl.isNotEmpty)
              Image.network(
                product.imagenUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              product.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${product.precio.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              product.descripcion,
              style: TextStyle(fontSize: 16),
            ),
            if (product.categoriaProducto.isNotEmpty)
              Text(
                'Categoría: ${product.categoriaProducto}',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
