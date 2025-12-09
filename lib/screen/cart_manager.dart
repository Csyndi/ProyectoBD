class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> cartItems = [];

  void addToCart(Map<String, dynamic> product) {
    // Si ya está en el carrito, aumenta quantity
    final index = cartItems.indexWhere((p) => p["id"] == product["id"]);

    if (index != -1) {
      cartItems[index]["qty"]++;
    } else {
      cartItems.add({
        "id": product["id"],
        "name": product["name"],
        "price": product["price"],
        "qty": 1,
      });
    }
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  void clearCart() {
    cartItems.clear();
  }
}
