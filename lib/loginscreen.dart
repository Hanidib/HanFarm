import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'signup.dart'; // Import the SignUpScreen
import 'home.dart'; // Import the Home screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var url = Uri.parse('http://hanfarm111.atwebpages.com/login.php');
    var response = await http.post(url, body: {
      'status': 'login',
      'email': email,
      'password_hash': password,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Handle successful login
        print('Login successful, User ID: ${data['id']}');
        setState(() {
          _errorMessage = '';
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        setState(() {
          _errorMessage = 'Email or password is invalid';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Request failed with status: ${response.statusCode}';
      });
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            image: AssetImage('assets/images/farmerbackground.png'),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black.withAlpha(3),
                      Colors.black.withAlpha(3),
                      Colors.black.withAlpha(3),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                )
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/Hanfarm.JPG'),
                      radius: 50,
                    ),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      fillColor: Color(0xffD8D8DD),
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      suffixIcon: Icon(Icons.visibility_off),
                      fillColor: Color(0xffD8D8DD),
                      filled: true,
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0ACF83),
                    foregroundColor: Colors.grey,
                    elevation: 20,
                    shadowColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 18.0, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('-----------', style: TextStyle(color: Colors.white, fontSize: 30)),
                      Text('Or Login With', style: TextStyle(color: Colors.white)),
                      Text('-----------', style: TextStyle(color: Colors.white, fontSize: 30)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color: const Color(0xff484848),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(Icons.g_mobiledata, color: Colors.white, size: 40),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color: const Color(0xff484848),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(Icons.apple, color: Colors.white, size: 40),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          color: const Color(0xff484848),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(Icons.facebook, color: Colors.white, size: 40),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100.0, top: 30),
                  child: Row(
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Signup()),
                          );
                        },
                        child: const Text(
                          " Sign up",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
