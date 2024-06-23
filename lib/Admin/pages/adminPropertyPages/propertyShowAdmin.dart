import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map/Admin/homeAdmin.dart';
import '../../../User/model/propertymodel.dart';
import './propertyCradAdmin.dart';
import '../profilepage/profilepage.dart';


class AdminPropertyPage extends StatefulWidget {
  const AdminPropertyPage({super.key});

  @override
  _AdminPropertyPageState createState() => _AdminPropertyPageState();
}

class _AdminPropertyPageState extends State<AdminPropertyPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Applied Properties',
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
        stream: FirebaseFirestore.instance.collection('appliedProperties').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var properties = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;

            return Property(
              id: doc.id,
              name: data['name'] ?? 'Unknown', // Default value if null
              description: data['description'] ?? 'No description',
              price: data['price'] ?? 0.0,
              location: data['location'] ?? 'No location',
              bedrooms: data['bedrooms'] ?? 0,
              bathrooms: data['bathrooms'] ?? 0,
              area: data['area'] ?? 0.0,
              imageUrls: List<String>.from(data['imageUrls'] ?? []),
              tenancyAgreementPeriod: data['tenancyAgreementPeriod'] ?? 0,
              status: data['status'] ?? 'unknown',
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PropertyCardAdmin(property: properties[index]),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminHome()),
              );
              break;
            case 1:
            // Stay on this page
              break;
            case 2:
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
