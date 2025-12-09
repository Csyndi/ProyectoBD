import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/screen/login_screen.dart';
import 'add_store_screen.dart';
import 'cart_screen.dart';
import 'store_detail_screen.dart';
import '../services/api_service.dart'; // Importar ApiService
import '../models/tienda.dart'; // Importar modelo Tienda

class HomeScreen extends StatefulWidget {
  final int usuarioId; // ID del usuario actual
  
  const HomeScreen({
    super.key,
    required this.usuarioId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Tienda> _stores = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _hasError = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  // Cargar tiendas desde la API
  Future<void> _loadStores() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Usar el método getTiendas de ApiService
      final tiendas = await _apiService.getTiendas();
      
      setState(() {
        _stores = tiendas;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar tiendas: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Obtener tiendas del usuario actual
  Future<void> _loadMyStores() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final misTiendas = await _apiService.getTiendasPorUsuario(widget.usuarioId);
      
      setState(() {
        _stores = misTiendas;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al cargar mis tiendas: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  // Filtrar tiendas por búsqueda
  List<Tienda> get _filteredStores {
    if (_searchQuery.isEmpty) return _stores;
    
    return _stores.where((tienda) {
      return tienda.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             tienda.descripcion.toLowerCase().contains(_searchQuery.toLowerCase()) ;
    }).toList();
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
          Text('Cargando tiendas...'),
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
            'Error al cargar tiendas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadStores,
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
          const Icon(Icons.store_mall_directory_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'No hay tiendas disponibles',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            'Sé el primero en crear una tienda',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Widget para el campo de búsqueda
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Buscar tiendas...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
    );
  }

  // Widget para los filtros
  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: const Text('Todas'),
            selected: true,
            onSelected: (selected) => _loadStores(),
            selectedColor: Colors.deepPurple,
            labelStyle: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Mis Tiendas'),
            onSelected: (selected) => _loadMyStores(),
            selectedColor: Colors.deepPurple,
            labelStyle: TextStyle(
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para el contador de tiendas
  Widget _buildStoreCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        _filteredStores.isEmpty 
          ? 'No se encontraron tiendas'
          : '${_filteredStores.length} tienda${_filteredStores.length == 1 ? '' : 's'} ${_searchQuery.isNotEmpty ? 'encontradas' : 'disponibles'}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiendas"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStores,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      
      body: _isLoading
          ? _buildLoadingState()
          : _hasError
              ? _buildErrorState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra de búsqueda
                    _buildSearchBar(),
                    
                    // Filtros
                    _buildFilterChips(),
                    
                    // Contador
                    _buildStoreCount(),
                    
                    const SizedBox(height: 8),
                    
                    // Lista de tiendas
                    Expanded(
                      child: _filteredStores.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _loadStores,
                              color: Colors.deepPurple,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredStores.length,
                                itemBuilder: (context, index) {
                                  final store = _filteredStores[index];
                              
                                  
                                  // Aquí necesitarías cargar la cantidad de productos de cada tienda
                                  // Por ahora usaré un valor por defecto o 0
                                  final productCount = 0; // Podrías implementar esto con otro endpoint

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => StoreDetailScreen(
                                            storeId: store.id,
                                            storeName: store.nombre,
                                          ),
                                        ),
                                      ).then((_) {
                                        // Recargar cuando regrese de detalle
                                        _loadStores();
                                      });
                                    },
                                    onLongPress: () {
                                      // Mostrar opciones para tiendas propias
                                      if (store.usuarioId == widget.usuarioId) {
                                        _showStoreOptions(store);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Imagen de la tienda
                                          Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: const BorderRadius.horizontal(
                                                left: Radius.circular(14),
                                              ),
                                              
                                                  
                                                 
                                            ),
                                            alignment: Alignment.center,
                                          
                                            
                                          ),
                                          
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          store.nombre,
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      if (store.usuarioId == widget.usuarioId)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green.shade50,
                                                            borderRadius: BorderRadius.circular(12),
                                                            border: Border.all(color: Colors.green),
                                                          ),
                                                          child: const Text(
                                                            'Mi Tienda',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors.green,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  
                                                  const SizedBox(height: 6),
                                                 
                                                  
                                                  const SizedBox(height: 4),
                                                  
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.location_on,
                                                          size: 14, color: Colors.deepPurple),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                               'Sin ubicación',
                                                          style: TextStyle(
                                                            color: Colors.grey.shade600,
                                                            fontSize: 12,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  
                                                  const SizedBox(height: 4),
                                                  
                                                  Text(
                                                    "${productCount} productos",
                                                    style: const TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          
                                          const Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: Icon(Icons.arrow_forward_ios,
                                                size: 18, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
      
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón: Agregar Tienda
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: FloatingActionButton(
              heroTag: "btnAddStore",
              backgroundColor: Colors.green,
              child: const Icon(Icons.add_business, color: Colors.white),
              onPressed: () async {
                final newStore = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddStoreScreen(
                      usuarioId: widget.usuarioId,
                    ),
                  ),
                );
                
                if (newStore != null) {
                  // Recargar tiendas después de crear una nueva
                  await _loadStores();
                }
              },
            ),
          ),

          // Botón: Carrito
          FloatingActionButton(
            heroTag: "btnCart",
            backgroundColor: Colors.deepOrange,
            child: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
            // Botón: Carrito
          FloatingActionButton(
            heroTag: "btnCart",
            backgroundColor: const Color.fromARGB(255, 214, 48, 48),
            child: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Mostrar opciones para tiendas propias
  void _showStoreOptions(Tienda tienda) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar Tienda'),
                onTap: () {
                  Navigator.pop(context);
                  _editStore(tienda);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Eliminar Tienda'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteStore(tienda);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.grey),
                title: const Text('Cancelar'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // Editar tienda
  void _editStore(Tienda tienda) {
    // Implementar pantalla de edición
    // Por ahora solo mostramos un mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar tienda: ${tienda.nombre}'),
      ),
    );
  }

  // Eliminar tienda
  Future<void> _deleteStore(Tienda tienda) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tienda'),
        content: Text('¿Estás seguro de eliminar "${tienda.nombre}"?\nEsta acción no se puede deshacer.'),
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
        await _apiService.deleteTienda(tienda.id);
        
        // Remover de la lista
        setState(() {
          _stores.removeWhere((t) => t.id == tienda.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tienda "${tienda.nombre}" eliminada'),
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

  @override
  void dispose() {
    _apiService.close();
    super.dispose();
  }
}