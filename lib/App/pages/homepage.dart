import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: Text("Settings")),
            ListTile(title: Text("Logout")),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Workshop Management System"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
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
            _buildTile("Profile", Icons.person, () {}),
            _buildTile("Schedule", Icons.calendar_today, () {}),
            _buildTile("Inventory", Icons.inventory, () {
              Navigator.pushNamed(context, '/inventory');
            }),
            _buildTile("Payment", Icons.credit_card, () {}),
            _buildTile("Rating", Icons.star, () {}),
            _buildTile("Activity Report", Icons.bar_chart, () {}),
          ],
        ),
      ),
    );
  }
}
