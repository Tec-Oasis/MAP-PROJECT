// import 'package:flutter/material.dart';
// import '../../model/tenancy.dart'; // Import the tenancy agreement model class
//
// class TenancyAgreementPage extends StatelessWidget {
//   final TenancyAgreement agreement;
//
//   // ignore: use_super_parameters
//   const TenancyAgreementPage({Key? key, required this.agreement})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tenancy Agreement Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildTitle(
//                 'Remaining Time in Agreement: ${agreement.remainingTime}'),
//             _buildTitle(
//                 'Amount to be Paid: \$${agreement.amountToBePaid.toStringAsFixed(2)}'),
//             const SizedBox(height: 20),
//             _buildTitle('Property Details:'),
//             const SizedBox(height: 10),
//             _buildPropertyDetails(agreement.property),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   Widget _buildPropertyDetails(Property property) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildDetailRow('Name', property.name),
//         _buildDetailRow('Description', property.description),
//         _buildDetailRow('Price', '\$${property.price.toStringAsFixed(2)}'),
//         _buildDetailRow('Location', property.location),
//         _buildDetailRow('Bedrooms', property.bedrooms.toString()),
//         _buildDetailRow('Bathrooms', property.bathrooms.toString()),
//         _buildDetailRow('Area', '${property.area} sq. ft.'),
//         _buildDetailRow(
//             'Tenancy Agreement Period', property.tenancyAgreementPeriod),
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120, // Adjust as needed for alignment
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
