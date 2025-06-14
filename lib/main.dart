import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:wms/App/Pages/ManageProfile/ChangePassword.dart';
import 'package:wms/App/Pages/ManageProfile/DeleteProfile.dart';
import 'package:wms/App/Pages/ManageProfile/EditProfile.dart';
import 'package:wms/App/Pages/ManageProfile/WorkshopOwner_ProfilePage.dart';

import 'package:wms/App/Domain/ManageShopInventory/Inventory.dart';
import 'package:wms/App/Pages/ManageShopInventory/EditDetailsForm.dart';
import 'package:wms/App/Pages/ManageShopInventory/InventoryDetail.dart';
import 'package:wms/App/Pages/ManageShopInventory/ShopInventory.dart';
import 'package:wms/App/Pages/ManageShopInventory/AddInventoryForm.dart';
import 'package:wms/App/Pages/RequestInventory/RequestInventory.dart';

import 'package:wms/App/Pages/homepage.dart';
import 'package:wms/App/Pages/ManageProfile/LoginPage.dart';
import 'package:wms/App/Pages/ManageProfile/Registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBq9vQeClLhk7S-P_6RCC0d-LbD1JwSfYA",
        authDomain: "wms2025-589e3.firebaseapp.com",
        databaseURL:
            "https://wms2025-589e3-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "wms2025-589e3",
        storageBucket: "wms2025-589e3.appspot.com",
        messagingSenderId: "1052215173330",
        appId: "1:1052215173330:web:46970592382c34d5618d0b",
        measurementId: "G-5XF5JF7XP6",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const WMSApp());
}

class WMSApp extends StatelessWidget {
  const WMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),

      home: const AuthWrapper(), // Use the wrapper
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/deleteProfile': (context) => const DeleteProfilePage(),
        '/changePassword': (context) => const ChangePasswordPage(),
        '/inventory': (context) => const ShopInventoryPage(),
        '/add-item': (context) => const navigateToAddForm(),
        '/request-item': (context) => const RequestInventoryPage(),


      
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item-detail') {
          final item = settings.arguments as Inventory;
          return MaterialPageRoute(
            builder: (context) => displayInventory(item: item),
          );
        } else if (settings.name == '/edit-item') {
          final item = settings.arguments as Inventory;
          return MaterialPageRoute(
            builder: (context) => EditDetailsForm(item: item),
          );
        }
        return null;
 
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in
      return HomePage(userId: user.uid);
    } else {
      // User is not signed in
      return const LoginPage();
    }
  }
}
