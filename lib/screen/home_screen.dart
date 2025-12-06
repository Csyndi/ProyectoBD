import 'package:flutter/material.dart';
import 'package:flutter_cakery_shop_ui/screen/add_store_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/cart_screen.dart';
import 'package:flutter_cakery_shop_ui/screen/store_detail_screen.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Lista de tiendas simuladas
  final List<Map<String, dynamic>> stores = [
    {
      "name": "Abarrotes Lupita",
      "image":
          "https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg",
      "category": "Abarrotes",
      "products": [
        {
          "name": "Coca Cola 600ml",
          "price": 18.0,
          "description": "Refresco Coca Cola botella 600ml",
          "image":
              "https://images.pexels.com/photos/4291/restaurant-alcohol-bar-drinks.jpg"
        },
        {
          "name": "Sabritas",
          "price": 12.0,
          "description": "Papas fritas sabor original",
          "image": ""
        },
      ]
    },
    {
      "name": "Ferretería El Martillo",
      "image":
          "https://images.pexels.com/photos/4481326/pexels-photo-4481326.jpeg",
      "category": "Ferretería",
      "products": [
        {
          "name": "Martillo de acero",
          "price": 85.0,
          "description": "Martillo resistente con mango ergonómico",
          "image": ""
        },
      ]
    },
    {
      "name": "Pastelería Delicia",
      "image":
          "https://images.pexels.com/photos/533325/pexels-photo-533325.jpeg",
      "category": "Pastelería",
      "products": [
        {
          "name": "Pastel de Chocolate",
          "price": 150.0,
          "description": "Pastel casero de chocolate con fresas",
          "image": ""
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiendas"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];

          // Valores seguros
          final String name = store["name"] ?? "Tienda sin nombre";
          final String category = store["category"] ?? "Categoría desconocida";
          final String image = store["image"] ?? "";
          final List products =
              store["products"] != null ? store["products"] : [];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoreDetailScreen(
                    store: {
                      "name": name,
                      "category": category,
                      "image": image,
                      "products": products,
                    },
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
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(14),
                      ),
                      image: image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: image.isEmpty
                        ? const Icon(Icons.store,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${products.length} productos",
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_forward_ios,
                        size: 18, color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        },
      ),floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  children: [

    // --- BOTÓN: AGREGAR TIENDA ---
    Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: FloatingActionButton(
        heroTag: "btnAddStore",
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_business, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddStoreScreen()),
          );
        },
      ),
    ),

    // --- BOTÓN: CARRITO ---
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
  ],
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
