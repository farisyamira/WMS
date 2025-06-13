import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wms/App/Pages/ManageProfile/LoginPage.dart';
import 'package:wms/App/Pages/ManageProfile/SearchPage.dart';
import 'package:wms/App/Pages/ManageProfile/WorkshopOwner_ProfilePage.dart';
import 'package:wms/App/Pages/ManageProfile/Foreman_ProfilePage.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Widget _buildTile(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = userData?['role'];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
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
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchPage(currentUserId: widget.userId),
                ),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Main Page",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildTile("Profile", Icons.person, () async {
              await _fetchUserData();
              if (userData == null) return;

              if (role == 'Workshop Owner') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkshopOwnerProfilePage(
                      ownerName: userData!['username'] ?? '',
                      email: userData!['email'] ?? '',
                      phone: userData!['phone'] ?? '',
                      workshopName: userData!['workshopName'] ?? '',
                      location: userData!['location'] ?? '',
                      operatingHours: userData!['operatingHours'] ?? '',
                      workshopDetails: userData!['workshopDetails'] ?? '',
                    ),
                  ),
                );
              } else if (role == 'Foreman') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForemanProfilePage(
                      foremanName: userData!['username'] ?? '',
                      email: userData!['email'] ?? '',
                      phone: userData!['phone'] ?? '',
                      skills:
                          (userData!['skills'] as List<dynamic>?)?.join(', ') ?? '',
                      type: userData!['type'] ?? '',
                      rating: (userData!['rating'] is num)
                          ? (userData!['rating'] as num).toDouble()
                          : 0.0,
                    ),
                  ),
                );
              }
            }),
            _buildTile("Schedule", Icons.calendar_today, () {}),
            if (role == 'Workshop Owner')
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
