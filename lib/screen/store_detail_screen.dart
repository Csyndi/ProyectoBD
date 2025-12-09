import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';
import '../models/producto.dart'; // Importar el modelo Producto
import '../services/api_service.dart'; // Importar ApiService

class StoreDetailScreen extends StatefulWidget {
  final int storeId; // Cambiar a int para el ID de la tienda
  final String storeName; // Nombre de la tienda

  const StoreDetailScreen({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  late List<Producto> _products = []; // Usar List<Producto> en lugar de List<Map>
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Cargar productos desde la API
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Usar el método getProductosPorTienda de ApiService
      final productos = await _apiService.getProductosPorTienda(widget.storeId);
      
      setState(() {
        _products = productos;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar productos: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Función para agregar un nuevo producto
  Future<void> _addNewProduct() async {
    // Aquí necesitas obtener el categoriaProductoId de alguna manera
    // Depende de cómo manejes las categorías en tu app
    final categoriaProductoId = await _showCategorySelectionDialog();
    
    if (categoriaProductoId != null) {
      final newProduct = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddProductScreen(
            tiendaId: widget.storeId,
            categoriaProductoId: categoriaProductoId,
          ),
        ),
      );

      if (newProduct != null && newProduct is Producto) {
        setState(() {
          _products.insert(0, newProduct); // Agregar al inicio de la lista
        });
        
        // Opcional: Recargar productos desde la API para asegurar consistencia
        await _loadProducts();
      }
    }
  }

  // Diálogo para seleccionar categoría (simplificado - debes adaptarlo a tus necesidades)
  Future<int?> _showCategorySelectionDialog() async {
    // Aquí debes implementar cómo obtienes las categorías
    // Por ahora, devolveré un valor fijo o mostraré un diálogo simple
    
    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Categoría'),
        content: const Text('Selecciona la categoría del producto'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 1), // ID de categoría 1
            child: const Text('Electrónicos'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 2), // ID de categoría 2
            child: const Text('Ropa'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 3), // ID de categoría 3
            child: const Text('Alimentos'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Función para eliminar un producto
  Future<void> _deleteProduct(Producto producto, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteProducto(producto.id);
        
        setState(() {
          _products.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Producto "${producto.nombre}" eliminado'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Widget para mostrar estado de carga
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          SizedBox(height: 20),
          Text('Cargando productos...'),
        ],
      ),
    );
  }

  // Widget para mostrar estado de error
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            'Error al cargar productos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar lista vacía
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'No hay productos',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            'Agrega tu primer producto',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar la lista de productos
  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _products.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final producto = _products[index];

        return Dismissible(
          key: Key('product-${producto.id}-${index}'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              await _deleteProduct(producto, index);
              return false; // Ya manejamos la eliminación en _deleteProduct
            }
            return false;
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: producto ),
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Imagen del producto
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      image: (producto.imagenUrl != null && producto.imagenUrl.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(producto.imagenUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (producto.imagenUrl == null || producto.imagenUrl.isEmpty)
                        ? const Icon(Icons.image, size: 40, color: Colors.grey)
                        : null,
                  ),

                  const SizedBox(width: 16),

                  // Información del producto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${producto.precio.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (producto.descripcion.isNotEmpty)
                          Text(
                            producto.descripcion,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (producto.categoriaProducto.isNotEmpty)
                          Text(
                            producto.categoriaProducto,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
            tooltip: 'Actualizar',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: _addNewProduct,
      ),

      body: RefreshIndicator(
        onRefresh: _loadProducts,
        color: Colors.deepPurple,
        child: _isLoading
            ? _buildLoadingState()
            : _hasError
                ? _buildErrorState()
                : _products.isEmpty
                    ? _buildEmptyState()
                    : _buildProductList(),
      ),
    );
  }

  @override
  void dispose() {
    _apiService.close();
    super.dispose();
  }
}