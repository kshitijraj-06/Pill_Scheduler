import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pillscheduler/services/signup.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";
  bool _obscurePassword = true;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (name.isEmpty) {
        setState(() => _errorMessage = "Name cannot be empty");
        return;
      }

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) throw Exception("Failed to get ID Token");

      SignupService signupService = SignupService();
      Map<String, dynamic>? userData = await signupService.signUpWithEmail(
        name,
        email,
        password,
        idToken,
      );

      if (userData != null) {
        Navigator.pushNamed(context, '/home');
        print("Signup Successful: $userData");
      } else {
        setState(() => _errorMessage = "Signup Failed");
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = "Firebase Error: ${e.message}");
    } catch (e) {
      setState(() => _errorMessage = "Unexpected Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildtopSignUp() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2.3,
          decoration: BoxDecoration(
            // color: Colors.black87,
            image: DecorationImage(
                image: AssetImage('assets/gif2.gif',),
                    fit: BoxFit.cover
            )
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    letterSpacing: .5,
                  ),
                ),
                Text(
                  'A New Account',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    letterSpacing: .5,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Create a New Account to Begin',
                  style: TextStyle(
                    fontFamily: 'MonaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    decoration: TextDecoration.none,
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

  Widget _buildTextFormField({
    required String? Function(String?)? validator,
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    required TextInputType keyboardType,
    bool isPasswordField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusColor: Colors.grey,
          fillColor: Colors.grey,
          labelText: labelText,
          labelStyle: TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: isPasswordField
              ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          )
              : null,
        ),
        validator: validator,
        obscureText: isPasswordField ? _obscurePassword : obscureText,
        keyboardType: keyboardType,
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
              _buildtopSignUp(),
              SizedBox(height: 20),
              _buildTextFormField(
                validator: (value) => value == null || value.isEmpty ? "Please enter your Name" : null,
                controller: _nameController,
                labelText: 'Name',
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              _buildTextFormField(
                validator: (value) => value == null || value.isEmpty ? "Please enter your email" : null,
                controller: _emailController,
                labelText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextFormField(
                validator: (value) => value == null || value.isEmpty ? "Please enter your password" : null,
                controller: _passwordController,
                labelText: 'Password',
                obscureText: false,
                keyboardType: TextInputType.text,
                isPasswordField: true,
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                height: 68,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: registerUser,
                    child: Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'MS-Bold',
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
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
                  'Or Sign Up With',
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
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'MS-Bold'),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontFamily: 'MS-Bold',
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}