import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/Provider/InventoryController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditDetailsForm extends StatefulWidget {
  final Inventory item;

  const EditDetailsForm({super.key, required this.item});

  @override
  State<EditDetailsForm> createState() => _EditDetailsFormState();
}

class _EditDetailsFormState extends State<EditDetailsForm> {
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  File? _imageFile;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final InventoryController _controller = InventoryController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.item_name);
    _barcodeController = TextEditingController(text: widget.item.item_barcode);
    _quantityController = TextEditingController(
      text: widget.item.quantity_available.toString(),
    );
    _priceController = TextEditingController(
      text: widget.item.unit_price.toString(),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = Inventory(
        inventory_id: widget.item.inventory_id,
        item_name: _nameController.text,
        imageUrl: _imageFile != null
            ? 'https://via.placeholder.com/150' // Change this to upload to Firebase Storage
            : widget.item.imageUrl,
        item_barcode: _barcodeController.text,
        quantity_available: int.parse(_quantityController.text),
        unit_price: double.parse(_priceController.text),
      );

      await _controller.updateItem(widget.item.inventory_id, updatedItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item updated successfully")),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Inventory Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Image.network(widget.item.imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Save'),
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
