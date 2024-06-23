import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signuppage.dart';
import '../home.dart';
import '../../../Admin/homeAdmin.dart';
import './passwordReset.dart';

class Login extends StatefulWidget {
  final photos = ['images/building.png', 'images/family.png'];

  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode focusEmail = FocusNode();
  FocusNode focusPass = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (_emailController.text.trim().endsWith('@admin.com')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHome()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Login Failed: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {});
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/building.png', height: 200.0, width: 200.0),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    controller: _emailController,
                    onTap: () {
                      setState(() {});
                    },
                    focusNode: focusEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade400,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blue,
                      )),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      hintText: 'Email',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    controller: _passwordController,
                    onTap: () {
                      setState(() {});
                    },
                    focusNode: focusPass,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      )),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.help,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {},
                      ),
                      hintText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff0165ff)),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey.shade600),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPasswordPage()),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
