import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/propertymodel.dart';

class PropertyDescriptionPage extends StatelessWidget {
  final String propertyId;

  const PropertyDescriptionPage({super.key, required this.propertyId});

  Future<Property> _fetchPropertyData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .get();
    return Property.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> _applyForProperty(
      BuildContext context, Property property) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to apply for a property')),
      );
      return;
    }

    final expirationDate = DateTime.now()
        .add(Duration(days: property.tenancyAgreementPeriod * 30));

    try {
      await FirebaseFirestore.instance.collection('appliedProperties').add({
        'userId': user.uid,
        'propertyId': propertyId,
        'name': property.name,
        'description': property.description,
        'price': property.price,
        'location': property.location,
        'bedrooms': property.bedrooms,
        'bathrooms': property.bathrooms,
        'area': property.area,
        'imageUrls': property.imageUrls,
        'tenancyAgreementPeriod': property.tenancyAgreementPeriod,
        'dateApplied': DateTime.now(),
        'expirationDate': expirationDate,
        'status': 'pending',
      });

      // Delete the property from the 'properties' collection
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .delete();

      // Show success dialog
      _showSuccessDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying for property: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Property Description',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        elevation: 0,
      ),
      body: FutureBuilder<Property>(
        future: _fetchPropertyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading property details'));
          }

          final property = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: property.imageUrls.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Color.fromRGBO(60, 77, 161, 1)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            property.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            property.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPropertyInfo(
                          'Price', '\$${property.price.toStringAsFixed(2)}'),
                      _buildPropertyInfo('Location', property.location),
                      _buildPropertyInfo(
                          'Bedrooms', property.bedrooms.toString()),
                      _buildPropertyInfo(
                          'Bathrooms', property.bathrooms.toString()),
                      _buildPropertyInfo('Area', '${property.area} sq. ft.'),
                      _buildPropertyInfo('Tenancy Agreement Period',
                          '${property.tenancyAgreementPeriod} months'),
                      const SizedBox(height: 20),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _applyForProperty(context, property);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              backgroundColor:
                                  const Color.fromRGBO(60, 77, 161, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Apply for Rent',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Application Successful'),
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 36),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'You have successfully applied for this property.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
