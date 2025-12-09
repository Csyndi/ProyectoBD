// lib/screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/screen/cart_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/store_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Lista de tiendas FIJAS (sin conexión a API)
  final List<Map<String, dynamic>> stores = [
    {
      "id": 1,
      "name": "Abarrotes Lupita",
      "image": "https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg",
      "category": "Abarrotes",
      "direccion": "Calle Principal #123",
      "telefono": "555-123-4567",
      "descripcion": "Tienda de abarrotes con los mejores precios",
    },
    {
      "id": 2,
      "name": "Ferretería El Martillo",
      "image": "https://images.pexels.com/photos/4481326/pexels-photo-4481326.jpeg",
      "category": "Ferretería",
      "direccion": "Av. Industria #456",
      "telefono": "555-987-6543",
      "descripcion": "Todo en herramientas y materiales de construcción",
    },
    {
      "id": 3,
      "name": "Pastelería Delicias",
      "image": "https://images.pexels.com/photos/533325/pexels-photo-533325.jpeg",
      "category": "Pastelería",
      "direccion": "Plaza Comercial #789",
      "telefono": "555-456-7890",
      "descripcion": "Los mejores pasteles y postres caseros",
    },
    {
      "id": 4,
      "name": "ElectroShop",
      "image": "https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg",
      "category": "Electrónica",
      "direccion": "Centro Comercial Moderno",
      "telefono": "555-111-2222",
      "descripcion": "Tecnología y electrónica de última generación",
    },
    {
      "id": 5,
      "name": "Ropa Moda",
      "image": "https://images.pexels.com/photos/994523/pexels-photo-994523.jpeg",
      "category": "Ropa",
      "direccion": "Boulevard de la Moda",
      "telefono": "555-333-4444",
      "descripcion": "Ropa para toda la familia a precios increíbles",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiendas Disponibles"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return _buildTiendaCard(store, context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnCart",
        backgroundColor: const Color.fromARGB(255, 255, 0, 98),
        child: const Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CartScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTiendaCard(Map<String, dynamic> store, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoreDetailScreen(
              tiendaId: store["id"], // Pasar el ID fijo
              tiendaNombre: store["name"],
              store: store,
            ),
          ),
        );
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
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen de la tienda
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
                image: store["image"] != null && store["image"].isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(store["image"]),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: store["image"] == null || store["image"].isEmpty
                  ? const Icon(Icons.store, size: 40, color: Colors.white)
                  : null,
            ),
            
            // Información
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store["name"] ?? "Tienda sin nombre",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store["category"] ?? "Categoría",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (store["direccion"] != null && store["direccion"].isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              store["direccion"],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            
            // Flecha
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}