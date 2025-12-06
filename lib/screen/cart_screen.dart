import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // 🛒 Carrito de ejemplo (puedes conectarlo a BD después)
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Pastel Chocolate",
      "price": 80.0,
      "qty": 2,
    },
    {
      "name": "Caja de Donas",
      "price": 50.0,
      "qty": 2,
    }
  ];

  // 🧮 Calcular total
  double get total {
    double sum = 0;
    for (var item in cartItems) {
      sum += item["price"] * item["qty"];
    }
    return sum;
  }

  // ➕ Incrementar cantidad
  void increaseQty(int index) {
    setState(() => cartItems[index]["qty"]++);
  }

  // ➖ Disminuir cantidad
  void decreaseQty(int index) {
    setState(() {
      if (cartItems[index]["qty"] > 1) {
        cartItems[index]["qty"]--;
      }
    });
  }

  // 🗑 Eliminar del carrito
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // 🧾 Mostrar ticket tipo recibo
  void showTicketModal() {
    final date = DateTime.now();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "COMPRA COMPLETADA",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),

            // TICKET
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("📍 MiniMarket Ltd.",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Fecha: $date"),
                  const Divider(),
                  ...cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item["name"]} x${item["qty"]}"),
                          Text("\$${item["price"] * item["qty"]}"),
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        "\$$total",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botones: Ver completo, Descargar, Cerrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text("Ver completo"),
                  onPressed: () {
                    Navigator.pop(context);
                    showFullTicket();
                  },
                ),
                TextButton(
                  child: const Text("Descargar"),
                  onPressed: () {
                    // Puedes usar screenshot + GallerySaver más adelante
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ticket descargado (simulado)')),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 🧾 Ticket pantalla completa
  void showFullTicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              const Center(
                child: Text(
                  "TICKET DE COMPRA",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ...cartItems.map((item) {
                return ListTile(
                  title: Text(item["name"]),
                  subtitle: Text("Cantidad: ${item["qty"]}"),
                  trailing:
                      Text("\$${item["price"] * item["qty"]}"),
                );
              }).toList(),
              const Divider(),
              Text("TOTAL: \$${total}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi carrito"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  final item = cartItems[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item["name"]),
                      subtitle: Text("\$${item["price"]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => decreaseQty(index),
                          ),
                          Text("${item["qty"]}"),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => increaseQty(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // TOTAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text(
                    "Total: \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("El carrito está vacío")),
                        );
                        return;
                      }
                      showTicketModal();
                    },
                    child: const Text(
                      "PROCEDER AL PAGO",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
