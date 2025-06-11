class Inventory {
  final String id;
  final String name;
  final String imageUrl;
  final int quantity;
  final String barcode;
  final double price;

  Inventory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.barcode,
    required this.quantity,
    required this.price,
  });

  factory Inventory.fromMap(Map<String, dynamic> data, String docId) {
    return Inventory(
      id: docId,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      quantity: data['quantity'] ?? 0,
      barcode: '',
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'imageUrl': imageUrl, 'quantity': quantity};
  }
}
