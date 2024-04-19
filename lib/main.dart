import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './User/pages/loginsignup/loginpage.dart';
import 'User/pages/homeStatus/noticationHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationHelper.initialize();
  runApp(const JMPS());
}

// main widget
class JMPS extends StatelessWidget {
  const JMPS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Login(),
    );
  }
}
