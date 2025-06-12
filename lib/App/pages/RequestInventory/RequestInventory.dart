import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/Provider/InventoryController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestInventoryPage extends StatefulWidget {
  const RequestInventoryPage({super.key});

  @override
  State<RequestInventoryPage> createState() => _RequestInventoryPageState();
}

class _RequestInventoryPageState extends State<RequestInventoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Inventory'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Request'),
            Tab(text: 'Items'),
            Tab(text: 'Incoming'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [RequestTab(), ItemsTab(), IncomingTab()],
      ),
    );
  }
}

class RequestTab extends StatelessWidget {
  const RequestTab({super.key});

  final List<Map<String, dynamic>> _requestedItems = const [
    {
      'name': 'Pliers Set',
      'barcode': '123456789012',
      'workshop': 'AKMAL Workshop (Pekan, Pahang)',
      'price': 'RM150.89',
      'status': 'APPROVED',
      'imageUrl': 'https://via.placeholder.com/60',
    },
    {
      'name': 'Socket Sets',
      'barcode': '245631879015',
      'workshop': 'MAJU Workshop (Pekan, Pahang)',
      'price': 'RM260.00',
      'status': 'PENDING',
      'imageUrl': 'https://via.placeholder.com/60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _requestedItems.length,
      itemBuilder: (context, index) {
        final item = _requestedItems[index];
        return Card(
          child: ListTile(
            leading: Image.network(item['imageUrl'], width: 60, height: 60),
            title: Text(
              item['name'],
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(item['barcode']), Text(item['workshop'])],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['price']),
                Text(
                  item['status'],
                  style: TextStyle(
                    color: item['status'] == 'APPROVED'
                        ? Colors.green
                        : item['status'] == 'REJECTED'
                        ? Colors.red
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemsTab extends StatelessWidget {
  const ItemsTab({super.key});

  final List<Map<String, dynamic>> _otherItems = const [
    {
      'name': 'Pliers Set',
      'barcode': '123456789012',
      'workshop': 'AKMAL Workshop (Pekan, Pahang)',
      'price': 'RM150.89',
      'quantity': 50,
      'imageUrl': 'https://via.placeholder.com/60',
    },
    {
      'name': 'Socket Sets',
      'barcode': '245631879015',
      'workshop': 'MAJU Workshop (Pekan, Pahang)',
      'price': 'RM260.00',
      'quantity': 13,
      'imageUrl': 'https://via.placeholder.com/60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _otherItems.length,
      itemBuilder: (context, index) {
        final item = _otherItems[index];
        return Card(
          child: ListTile(
            leading: Image.network(item['imageUrl'], width: 60, height: 60),
            title: Text(
              item['name'],
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(item['barcode']), Text(item['workshop'])],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Qty: ${item['quantity']}"),
                Text(item['price']),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/workshop-inventory',
                      arguments: item,
                    );
                  },
                  child: const Text('Request'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IncomingTab extends StatelessWidget {
  const IncomingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Incoming requests from other workshops will appear here."),
    );
  }
}
