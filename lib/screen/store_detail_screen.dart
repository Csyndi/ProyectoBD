import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';

class StoreDetailScreen extends StatefulWidget {
  final Map<String, dynamic> store;

  const StoreDetailScreen({
    super.key,
    required this.store,
  });

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  late List<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();

    // Asegurar lista válida de productos
    products = List<Map<String, dynamic>>.from(widget.store["products"] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return Scaffold(
      appBar: AppBar(
        title: Text(store["name"] ?? "Tienda"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.deepPurple,
  child: const Icon(Icons.add),
 onPressed: () async {
  final newProduct = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AddProductScreen(),
    ),
  );

  if (newProduct != null) {
    setState(() => products.add(newProduct));
  }
},

),


      body: ListView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final p = products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: p),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Imagen
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      image: (p["image"] != null && p["image"] != "")
                          ? DecorationImage(
                              image: NetworkImage(p["image"]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (p["image"] == null || p["image"] == "")
                        ? const Icon(Icons.image, size: 40, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(width: 16),

                  // Información
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p["name"] ?? "Producto",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${p["price"]?.toStringAsFixed(2) ?? "0.00"}",
                          style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
