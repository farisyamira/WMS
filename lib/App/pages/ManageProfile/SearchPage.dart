import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wms/App/Pages/ManageProfile/Foreman_ProfilePage.dart';
import 'package:wms/App/Pages/ManageProfile/WorkshopOwner_ProfilePage.dart';

class SearchPage extends StatefulWidget {
  final String currentUserId;

  const SearchPage({super.key, required this.currentUserId});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  void _performSearch(String query) async {
  if (query.isEmpty) {
    setState(() => searchResults.clear());
    return;
  }

  // Search lowercase keyword
  final lowerQuery = query.toLowerCase();

  final result = await FirebaseFirestore.instance
      .collection('users')
      .where('keywords', arrayContains: lowerQuery)
      .get();

  final filtered = result.docs
      .where((doc) => doc.id != widget.currentUserId)
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();

  setState(() {
    searchResults = filtered;
  });
}


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToProfile(Map<String, dynamic> userData) {
    final role = userData['role'];
    if (role == 'Workshop Owner') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkshopOwnerProfilePage(
            ownerName: userData['username'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            workshopName: userData['workshopName'] ?? '',
            location: userData['location'] ?? '',
            operatingHours: userData['operatingHours'] ?? '',
            workshopDetails: userData['workshopDetails'] ?? '',
            isMe: false,
          ),
        ),
      );
    } else if (role == 'Foreman') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForemanProfilePage(
            foremanName: userData['username'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            skills: (userData['skills'] as List<dynamic>?)?.join(', ') ?? '',
            type: userData['type'] ?? '',
            rating: (userData['rating'] is num)
                ? (userData['rating'] as num).toDouble()
                : 0.0,
            isMe: false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter name or email',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
              onSubmitted: _performSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(user['username'] ?? 'No Name'),
                            subtitle: Text(user['email'] ?? ''),
                            onTap: () => _navigateToProfile(user),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
