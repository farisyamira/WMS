import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/ManageShopInventory/Inventory.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = "inventory";

  Future<List<Inventory>> getInventoryItems() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Inventory.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addItem(Inventory item) async {
    await _firestore.collection(_collection).add(item.toMap());
  }

  Future<Inventory?> getItemById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Inventory.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}
