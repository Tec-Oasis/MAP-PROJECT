import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/propertymodel.dart';
import '../profilepage/profilepage.dart';
import '../propertysubmission/submission.dart';
import './propertyCardStatus.dart';
import '../home.dart';

class Homestatus extends StatefulWidget {
  const Homestatus({super.key});

  @override
  _HomestatusState createState() => _HomestatusState();
}

class _HomestatusState extends State<Homestatus> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: const Center(
          child: Text('You need to be logged in to see applied properties'),
        ),
      );
    }

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
        stream: FirebaseFirestore.instance
            .collection('appliedProperties')
            .where('userId', isEqualTo: user.uid)
            .where('status',
                isEqualTo: 'pending') // Only show approved properties
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var properties = snapshot.data!.docs.map((doc) {
            var property =
                Property.fromJson(doc.data() as Map<String, dynamic>);
            property.id = doc.id;
            return property;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PropertyCardWithStatus(property: properties[index]),
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
                MaterialPageRoute(builder: (context) => const Home()),
              );
              break;
            case 1:
              // Stay on this page
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const finalHome()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
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
            icon: Icon(Icons.check_circle_outline, size: 30),
            label: 'Approved Properties',
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
