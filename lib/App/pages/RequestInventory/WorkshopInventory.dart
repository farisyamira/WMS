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
            child: ListTile(
              leading: Image.network(
                item.imageUrl,
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
              ),
              title: Text(
                item.item_name,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(item.item_barcode), Text('$workshopName')],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('RM${item.unit_price.toStringAsFixed(2)}'),
                  ElevatedButton(
                    onPressed: () => _sendRequest(context, item),
                    child: const Text('Request'),
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
