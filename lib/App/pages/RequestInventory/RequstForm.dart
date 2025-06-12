import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/Provider/InventoryController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestFormPage extends StatefulWidget {
  final Inventory item;

  const RequestFormPage({super.key, required this.item});

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _requestedQuantityController =
      TextEditingController();

  @override
  void dispose() {
    _requestedQuantityController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final int quantity = int.parse(_requestedQuantityController.text);

      try {
        await FirebaseFirestore.instance.collection('requests').add({
          'item_name': widget.item.item_name,
          'imageUrl': widget.item.imageUrl,
          'quantity_requested': quantity,
          'workshop_name': widget.item.workshop_name,
          'request_status': 'PENDING',
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request submitted for ${widget.item.item_name}'),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit request: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Request Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  item.imageUrl,
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Workshop: ${item.workshop_name}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Item Name: ${item.item_name}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Available Quantity: ${item.quantity_available}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _requestedQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity to Request',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter quantity';
                  if (int.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    child: const Text('Save Request'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
