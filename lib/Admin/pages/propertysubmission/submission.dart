import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../User/model/propertymodel.dart';

class PropertySubmitPage extends StatefulWidget {
  const PropertySubmitPage({super.key});

  @override
  _PropertySubmitPageState createState() => _PropertySubmitPageState();
}

class _PropertySubmitPageState extends State<PropertySubmitPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _tenancyAgreementPeriodController = TextEditingController();
  final List<TextEditingController> _imageControllers = [TextEditingController()];

  void _addImageField() {
    setState(() {
      _imageControllers.add(TextEditingController());
    });
  }

  void _removeImageField(int index) {
    setState(() {
      _imageControllers.removeAt(index);
    });
  }

  Future<void> _submitProperty() async {
    if (_formKey.currentState!.validate()) {
      List<String> imageUrls = _imageControllers.map((controller) => controller.text).toList();

      Property property = Property(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        location: _locationController.text,
        bedrooms: int.parse(_bedroomsController.text),
        bathrooms: int.parse(_bathroomsController.text),
        area: double.parse(_areaController.text),
        imageUrls: imageUrls,
        tenancyAgreementPeriod: int.parse(_tenancyAgreementPeriodController.text),
        status: 'pending',
      );

      try {
        await FirebaseFirestore.instance.collection('properties').add(property.toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property submitted successfully')),
        );

        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _locationController.clear();
        _bedroomsController.clear();
        _bathroomsController.clear();
        _areaController.clear();
        _tenancyAgreementPeriodController.clear();
        setState(() {
          _imageControllers.forEach((controller) => controller.clear());
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting property: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Property'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_descriptionController, 'Description'),
              _buildTextField(_priceController, 'Price', keyboardType: TextInputType.number),
              _buildTextField(_locationController, 'Location'),
              _buildTextField(_bedroomsController, 'Bedrooms', keyboardType: TextInputType.number),
              _buildTextField(_bathroomsController, 'Bathrooms', keyboardType: TextInputType.number),
              _buildTextField(_areaController, 'Area (sqft)', keyboardType: TextInputType.number),
              _buildTextField(_tenancyAgreementPeriodController, 'Tenancy Agreement Period (months)', keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              const Text('Image URLs:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ..._imageControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Image URL ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeImageField(index),
                    ),
                  ],
                );
              }).toList(),
              TextButton.icon(
                onPressed: _addImageField,
                icon: const Icon(Icons.add_circle, color: Colors.green),
                label: const Text('Add another image', style: TextStyle(color: Colors.green)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProperty,
                child: const Text('Submit Property'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      ),
    );
  }
}
