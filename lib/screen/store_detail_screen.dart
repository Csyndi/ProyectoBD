import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/data/local_product_db.dart';
import 'package:flutter_cakery_shop_ui/screen/add_product_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/cart_manager.dart';
import 'edit_product_screen.dart';

class StoreDetailScreen extends StatefulWidget {
  final int tiendaId;
  final String tiendaNombre;
  final Map<String, dynamic> store;

  const StoreDetailScreen({
    Key? key,
    required this.tiendaId,
    required this.tiendaNombre,
    required this.store,
  }) : super(key: key);

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() {
    setState(() {
      isLoading = false;
      products = LocalProductDB().getProductos(widget.tiendaId);
    });
  }

  void _eliminarProducto(int index) {
    final product = products[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar producto"),
        content: Text('¿Eliminar "${product['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              LocalProductDB().removeProducto(widget.tiendaId, index);
              setState(() {
                products = LocalProductDB().getProductos(widget.tiendaId);
              });
              Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tiendaNombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProductos,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProductScreen(
                tiendaId: widget.tiendaId,
                tiendaNombre: widget.tiendaNombre,
              ),
            ),
          ).then((value) {
            if (value == true) {
              _cargarProductos();
            }
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (products.isEmpty) {
      return const Center(
        child: Text(
          "No hay productos en esta tienda",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Image.network(
              product['image'],
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            title: Text(product['name']),
            subtitle: Text(product['description'] ?? ''),

            // 👉 ICONOS: agregar al carrito + borrar
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🟩 AGREGAR AL CARRITO
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                  onPressed: () {
                    CartManager().addToCart(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("${product['name']} agregado al carrito"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),

                // 🗑 BORRAR
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _eliminarProducto(index),
                ),
              ],
            ),

            // 👉 EDITAR
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                    tiendaId: widget.tiendaId,
                    index: index,
                    product: product,
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  _cargarProductos();
                }
              });
            },
          ),
        );
      },
    );
  }
}
