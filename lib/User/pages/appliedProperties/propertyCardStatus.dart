import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../../model/propertymodel.dart';
import './propertyDescStatus.dart';

class PropertyCardWithStatus extends StatelessWidget {
  final Property property;

  const PropertyCardWithStatus({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDescStatus(
                propertyId: property.id!, status: property.status),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                property.imageUrls[0],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
                color: Color.fromRGBO(30, 30, 30, 1),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Status: ${property.status}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
