import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wms/App/Pages/ManageProfile/LoginPage.dart';
import 'package:wms/App/Pages/ManageProfile/WorkshopOwner_ProfilePage.dart';
import 'package:wms/App/Pages/ManageProfile/Foreman_ProfilePage.dart';

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  Widget _buildTile(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const ListTile(title: Text("Settings")),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Workshop Management System"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 8),
              child: Text(
                "Main Page",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            _buildTile("Profile", Icons.person, () async {
              try {
                final doc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get();

                final data = doc.data();

                if (data == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User data not found")),
                  );
                  return;
                }

                final role = data['role']?.toString();

                if (role == 'Workshop Owner') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkshopOwnerProfilePage(
                        ownerName: data['username']?.toString() ?? '',
                        email: data['email']?.toString() ?? '',
                        phone: data['phone']?.toString() ?? '',
                        workshopName: data['workshopName']?.toString() ?? '',
                        location: data['location']?.toString() ?? '',
                      ),
                    ),
                  );
                } else if (role == 'Foreman') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForemanProfilePage(
                        foremanName: data['username']?.toString() ?? '',
                        email: data['email']?.toString() ?? '',
                        phone: data['phone']?.toString() ?? '',
                        skills: (data['skills'] as List<dynamic>?)
                                ?.join(', ') ??
                            '',
                        type: data['type']?.toString() ?? '',
                        rating: (data['rating'] is num)
                            ? (data['rating'] as num).toDouble()
                            : 0.0,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Unknown role")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
            }),
            _buildTile("Schedule", Icons.calendar_today, () {}),
            _buildTile("Inventory", Icons.inventory, () {}),
            _buildTile("Payment", Icons.credit_card, () {}),
            _buildTile("Rating", Icons.star, () {}),
            _buildTile("Activity Report", Icons.bar_chart, () {}),
          ],
        ),
      ),
    );
  }
}
