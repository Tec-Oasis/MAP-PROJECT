import 'package:flutter/material.dart';
import '../User/pages/propertycard/propertycard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../User/model/propertymodel.dart';
import './pages/profilepage/profilepage.dart';
import './pages/propertysubmission/submission.dart';
import './pages/adminPropertyPages/propertyShowAdmin.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Al Jazeera',
            style: TextStyle(
              fontFamily: 'YourCustomFont',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('properties').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var properties = snapshot.data!.docs.map((doc) {
            var property = Property.fromJson(doc.data() as Map<String, dynamic>);
            property.id = doc.id;
            return property;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PropertyCard(property: properties[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PropertySubmitPage()),
          );
        },
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
            // Home - Do nothing, already on home
              break;
            case 1:
            // Navigate to admin property page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPropertyPage()),
              );
              break;
            case 2:
            // Navigate to profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake, size: 30),
            label: 'Applied Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
