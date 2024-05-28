import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:map/User/pages/appliedProperties/list.dart';
import '../model/propertymodel.dart';
import '../pages/profilepage/profilepage.dart';
import './propertysubmission/submission.dart';
import './homeStatus/noticationHelper.dart';
import './propertycard/propertycard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    NotificationHelper.initialize();
    _scheduleContractExpirationNotifications();
  }

  void _scheduleContractExpirationNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final propertiesSnapshot = await FirebaseFirestore.instance
        .collection('appliedProperties')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'approved')
        .get();

    final now = DateTime.now();
    for (var doc in propertiesSnapshot.docs) {
      var property = Property.fromJson(doc.data() as Map<String, dynamic>);
      property.id = doc.id;

      Timestamp expirationTimestamp = doc['expirationDate'];
      DateTime expirationDate = expirationTimestamp.toDate();

      final daysLeft = expirationDate.difference(now).inDays;
      if (daysLeft <= 31) {
        NotificationHelper.showNotification(
          property.id.hashCode,
          'Contract Expiration Reminder',
          'Your contract for ${property.name} expires in $daysLeft days. Please renew it.',
        );
      }
    }
  }

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
                child: PropertyCard(property: properties[index]),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Homestatus()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const finalHome()),
              );
              break;
            case 3:
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
