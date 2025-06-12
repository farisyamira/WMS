import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/Provider/InventoryController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopInventoryPage extends StatefulWidget {
  const ShopInventoryPage({super.key});

  @override
  State<ShopInventoryPage> createState() => _ShopInventoryPageState();
}

class _ShopInventoryPageState extends State<ShopInventoryPage> {
  final InventoryController _controller = InventoryController();
  List<Inventory> _items = [];

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (doc.exists && doc['role'] != 'Workshop Owner') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access denied: Workshop Owners only.')),
        );
        Navigator.pop(context);
      }
    } else {
      _fetchItems();
    }
  }

  void _fetchItems() async {
    final items = await _controller.getInventoryItems();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Inventory"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 8),
              child: Text(
                "Items List",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/add-item');
                    _fetchItems();
                  },
                  child: const Text('Add Item'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/request-item'),
                  child: const Text('Request Item'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    title: Text(
                      item.item_name,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.quantity_available.toString()),
                        const Text(
                          "View Details",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/item-detail',
                        arguments: item,
                      );

                      if (result == true) {
                        _fetchItems(); // Refresh list if item was deleted
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
