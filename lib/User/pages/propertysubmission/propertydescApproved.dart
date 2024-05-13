import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../User/model/propertymodel.dart';
import 'package:intl/intl.dart';

class PropertyDescriptionApproved extends StatelessWidget {
  final String propertyId;

  const PropertyDescriptionApproved({Key? key, required this.propertyId})
      : super(key: key);

  Future<Map<String, dynamic>> _fetchPropertyData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('appliedProperties')
        .doc(propertyId)
        .get();
    return snapshot.data() as Map<String, dynamic>;
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchPropertyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading property details'));
          }

          final data = snapshot.data!;
          final property = Property.fromJson(data);
          final expirationDate = (data['expirationDate'] as Timestamp).toDate();
          final formattedExpirationDate =
              DateFormat('yyyy-MM-dd').format(expirationDate);
          final now = DateTime.now();
          final daysLeft = expirationDate.difference(now).inDays;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  property.imageUrls[0],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
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
                      _buildPropertyInfo('Status', property.status),
                      _buildPropertyInfo(
                          'Expiration Date', formattedExpirationDate),
                      _buildPropertyInfo('Days Left', '$daysLeft days'),
                      const SizedBox(height: 20),
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
}
