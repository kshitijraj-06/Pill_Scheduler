import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin ? 'Welcome Back!' : 'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            _isLogin ? 'Login' : 'Sign Up',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: _submitForm,
                        ),
                        TextButton(
                          child: Text(
                            _isLogin
                                ? 'Create new account'
                                : 'I already have an account',
                            style: TextStyle(color: Colors.blue.shade800),
                          ),
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.login),
                          label: Text('Sign in with Google'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                            onPressed: () {
                            signup(context);
                            }
                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String idToken) async {
    const String loginUrl = 'http://172.28.0.1:8080/user/fetch';
    const String authHeader = 'Authorization';
    const String contentTypeHeader = 'Content-Type';
    const String contentTypeJson = 'application/json';

    final url = Uri.parse(loginUrl);

    // Prepare the JSON payload
    final body = jsonEncode({
      'idToken': idToken,
    });

    try {
      final response = await http.get(
        url,
        headers: {
          authHeader: 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully logged in, navigate to the home screen
        Navigator.pushNamed(context, '/home');
      } else {
        // Handle specific errors
        if (response.statusCode == 401) {
          print('Unauthorized: Invalid token');
        } else if (response.statusCode == 500) {
          print('Server error: ${response.body}');
        } else {
          print('Login failed: ${response.body}');
        }
        // Show user feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      // Show user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $e')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential;
        if (_isLogin) {
          // Sign in with email and password.
          userCredential = await auth.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          );
        } else {
          // Create a new account with email and password.
          userCredential = await auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );
        }
        // Generate ID token for the authenticated user.
        String? idToken = await userCredential.user!.getIdToken();
        print("Generated ID Token: $idToken");

        // Use the login endpoint to verify the token.
        await loginUser(idToken!);
      } catch (e) {
        print("Error: $e");
        // Optionally, show an error dialog to the user.
      }
    }
  }




  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      //User user = result.user;

      print('CLicked');  // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }
}


