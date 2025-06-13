import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  final String inventory_id;
  final String item_name;
  final String imageUrl;
  final int quantity_available;
  final String item_barcode;
  final double unit_price;
  final String workshop_name;
  final DateTime? item_created;
  final DateTime? item_updated;

  Inventory({
    required this.inventory_id,
    required this.item_name,
    required this.imageUrl,
    required this.quantity_available,
    required this.item_barcode,
    required this.unit_price,
    required this.workshop_name,
    this.item_created,
    this.item_updated,
  });

  factory Inventory.fromMap(Map<String, dynamic> data, String docId) {
    return Inventory(
      inventory_id: docId,
      item_name: data['item_name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      quantity_available: data['quantity_available'] ?? 0,
      item_barcode: data['itemBarcode'] ?? '',
      unit_price: (data['unit_price'] ?? 0.0).toDouble(),
      workshop_name: data['workshop_name'] ?? '',
      item_created: (data['item_created'] as Timestamp?)?.toDate(),
      item_updated: (data['item_updated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_name': item_name,
      'imageUrl': imageUrl,
      'quantity_available': quantity_available,
      'itemBarcode': item_barcode,
      'unit_price': unit_price,
      'workshop_name': workshop_name,
      'item_created':
          FieldValue.serverTimestamp(), // For Firestore auto timestamp
      'item_updated': FieldValue.serverTimestamp(),
    };
  }
}
