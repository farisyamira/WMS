import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/Provider/InventoryController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkshopInventoryPage extends StatelessWidget {
  final List<Inventory> workshopItems;
  final String workshopName;

  const WorkshopInventoryPage({
    super.key,
    required this.workshopItems,
    required this.workshopName,
  });

  void _sendRequest(BuildContext context, Inventory item) {
    // TODO: Add logic to send request to Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request sent for ${item.item_name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$workshopName Inventory')),
      body: ListView.builder(
        itemCount: workshopItems.length,
        itemBuilder: (context, index) {
          final item = workshopItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    item.imageUrl,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.item_name,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(item.item_barcode),
                        Text(workshopName),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('RM${item.unit_price.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () => _sendRequest(context, item),
                        child: const Text('Request'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
