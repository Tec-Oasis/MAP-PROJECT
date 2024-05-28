// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../appliedProperties/list.dart';
import '../home.dart';
import '../loginsignup/loginpage.dart';
import '../propertysubmission/submission.dart';
import '../tenancaypage.dart/tenancy.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<Map<String, dynamic>> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data() as Map<String, dynamic>;
    }
    return {};
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });

      // Update email
      await user.updateEmail(_emailController.text);

      // Update password
      if (_passwordController.text.isNotEmpty) {
        await user.updatePassword(_passwordController.text);
      }

      // Show success dialog
      _showSuccessDialog(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          final userProfile = snapshot.data ?? {};
          _nameController.text = userProfile['name'] ?? '';
          _emailController.text = userProfile['email'] ?? '';
          _phoneController.text = userProfile['phone'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  child: const Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 160,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileField(
                  label: 'Name',
                  controller: _nameController,
                ),
                ProfileField(
                  label: 'Email',
                  controller: _emailController,
                ),
                ProfileField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                ProfileField(
                  label: 'Password',
                  controller: _passwordController,
                  isObscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateUserData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(60, 77, 161, 1),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
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
            // Do nothing, already on profile page
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                'Profile Updated Successfully',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputType keyboardType;

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.isObscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        obscureText: isObscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
