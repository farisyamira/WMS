import 'package:flutter/material.dart';
import 'package:wms/App/domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/provider/InventoryController.dart';

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
    _fetchItems();
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-item');
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
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.quantity.toString()),
                        const Text(
                          "View Details",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/item-detail',
                      arguments: item.id,
                    ),
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
