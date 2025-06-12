import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wms/App/Provider/InventoryController.dart';

class displayInventory extends StatelessWidget {
  final Inventory item;

  const displayInventory({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: item.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(item.imageUrl, fit: BoxFit.cover),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 20),

            // Item Name
            _buildDetailRow("Item Name", item.item_name),
            const SizedBox(height: 10),

            // Barcode
            _buildDetailRow("Barcode", item.item_barcode),
            const SizedBox(height: 10),

            // Quantity
            _buildDetailRow("Quantity", item.quantity_available.toString()),
            const SizedBox(height: 10),

            // Price
            _buildDetailRow(
              "Price",
              "RM ${item.unit_price.toStringAsFixed(2)}",
            ),
            const SizedBox(height: 30),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/edit-item',
                      arguments: item,
                    );
                    if (result == true) {
                      Navigator.pop(context, true); // reload list
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final controller = InventoryController();
                    await controller.deleteItem(item.inventory_id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item deleted")),
                    );

                    Navigator.pop(context, true); // Go back to inventory list
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
