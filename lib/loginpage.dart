import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _loginUser(String idToken) async {
    const String loginUrl = 'https://minorproject-yytm.onrender.com/user/fetch';

    try {
      final response = await http.get(
        Uri.parse(loginUrl),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Token : $idToken');
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        final String? idToken = await userCredential.user?.getIdToken();
        if (idToken != null) {
          await _loginUser(idToken);
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firebase Error: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2.3,
          decoration: const BoxDecoration(color: Colors.black87),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
                const Text(
                  'Log In to Continue',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Enter your credentials',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required bool isPassword,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          )
              : null,
        ),
        obscureText: isPassword ? _obscurePassword : false,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
              children: [
              _buildHeader(),
          SizedBox(height: 20,),
          _buildInputField(
            label: 'Email',
            isPassword: false,
            onSaved: (value) => _email = value!.trim(),
            validator: (value) =>
            value?.isEmpty ?? true ? 'Enter valid email' : null,
          ),
          _buildInputField(
            label: 'Password',
            isPassword: true,
            onSaved: (value) => _password = value!.trim(),
            validator: (value) =>
            value?.isEmpty ?? true ? 'Enter password' : null,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _submitForm,
              child: const Text(
                'LOG IN',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MS-Bold',
                  color: Colors.black,
                ),
              ),
            )
          ),
                SizedBox(height: 20),
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(color: Colors.black),
                    ),
                  ),
                  Text(
                    'Or Sign In With',
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                      child: Divider(color: Colors.black),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 15),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.3,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/logo.png',
                              height: 40,
                              width: 40,),
                            Text('Google',
                              style: TextStyle(
                                  fontFamily: 'MS-Bold',
                                  fontSize: 19,
                                  color: Colors.grey
                              ),),
                          ],
                        ),
                      ),
                      SizedBox(width: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width/2.3,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/fb.png',
                              height: 35,
                              width: 35,),
                            SizedBox(width: 5,),
                            Text('Facebook',
                              style: TextStyle(
                                  fontFamily: 'MS-Bold',
                                  fontSize: 19,
                                  color: Colors.grey
                              ),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/signup'),
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}