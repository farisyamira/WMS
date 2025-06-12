import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  final _typeController = TextEditingController();
  final _workshopNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _operatingHoursController = TextEditingController();
  final _workshopDetailsController = TextEditingController();

  bool _loading = true;
  String? _role;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _role = data?['role'];
          _usernameController.text = data?['username'] ?? '';
          _emailController.text = data?['email'] ?? '';
          _phoneController.text = data?['phone'] ?? '';
          _skillsController.text =
              (data?['skills'] as List<dynamic>?)?.join(', ') ?? '';
          _typeController.text = data?['type'] ?? '';
          _workshopNameController.text = data?['workshopName'] ?? '';
          _locationController.text = data?['location'] ?? '';
          _operatingHoursController.text = data?['operatingHours'] ?? '';
          _workshopDetailsController.text = data?['workshopDetails'] ?? '';
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Map<String, dynamic> updatedData = {
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      if (_role == 'Foreman') {
        updatedData['skills'] =
            _skillsController.text.trim().split(',').map((e) => e.trim()).toList();
        updatedData['type'] = _typeController.text.trim();
      } else if (_role == 'Workshop Owner') {
        updatedData['workshopName'] = _workshopNameController.text.trim();
        updatedData['location'] = _locationController.text.trim();
        updatedData['operatingHours'] = _operatingHoursController.text.trim();
        updatedData['workshopDetails'] = _workshopDetailsController.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Update error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration:
                              _inputDecoration('Fullname', Icons.person),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration('Email', Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || !value.contains('@')
                              ? 'Invalid email'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration('Phone', Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value == null || value.length < 10
                              ? 'Invalid phone'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        if (_role == 'Foreman') ...[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 8),
                              child: Text(
                                "Foreman Info",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _typeController,
                            decoration:
                                _inputDecoration('Foreman Type', Icons.build),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _skillsController,
                            decoration: _inputDecoration(
                                'Skills (comma-separated)', Icons.handyman),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_role == 'Workshop Owner') ...[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 8),
                              child: Text(
                                "Workshop Owner Info",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _workshopNameController,
                            decoration: _inputDecoration(
                                'Workshop Name', Icons.home_work),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _locationController,
                            decoration:
                                _inputDecoration('Location', Icons.location_on),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _operatingHoursController,
                            decoration: _inputDecoration(
                                'Operating Hours', Icons.access_time),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _workshopDetailsController,
                            decoration: _inputDecoration(
                                'Workshop Detail', Icons.info_outline),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save),
                          label: const Text("Save Changes"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(204, 36, 72, 236),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    _typeController.dispose();
    _workshopNameController.dispose();
    _locationController.dispose();
    _operatingHoursController.dispose();
    _workshopDetailsController.dispose();
    super.dispose();
  }
}
