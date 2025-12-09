// lib/data/local_product_db.dart
class LocalProductDB {
  static final LocalProductDB _instance = LocalProductDB._internal();
  factory LocalProductDB() => _instance;
  LocalProductDB._internal();

  final Map<int, List<Map<String, dynamic>>> _storeProducts = {};

  List<Map<String, dynamic>> getProductos(int tiendaId) {
    return _storeProducts[tiendaId] ?? [];
  }

  void addProducto(int tiendaId, Map<String, dynamic> product) {
    final list = _storeProducts.putIfAbsent(tiendaId, () => []);
    list.add(product);
  }

  void removeProducto(int tiendaId, int index) {
    final list = _storeProducts[tiendaId];
    if (list == null) return;
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
  }

  // <-- Asegúrate de tener exactamente este método
  void updateProducto(int tiendaId, int index, Map<String, dynamic> updated) {
    final list = _storeProducts[tiendaId];
    if (list == null) return;
    if (index < 0 || index >= list.length) return;
    list[index] = updated;
  }
}
