import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';

class InventoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = "Inventory";

  Future<List<Inventory>> getInventoryItems() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Inventory.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addItem(Inventory item) async {
    try {
      await _firestore.collection(_collection).add(item.toMap());
      print("Firestore write successful");
    } catch (e) {
      print("Firestore write error: $e");
    }
  }

  Future<Inventory?> getItemById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Inventory.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> deleteItem(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      print("Item with ID $id deleted.");
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  Future<void> updateItem(String id, Inventory updatedItem) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(updatedItem.toMap());
      print("Item updated successfully.");
    } catch (e) {
      print("Error updating item: $e");
    }
  }
}
