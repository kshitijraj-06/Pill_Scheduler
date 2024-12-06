import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:pillscheduler/dashboard.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override

  Future<Map<String, dynamic>> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the Google sign-in
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential and access token
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    return {
      'userCredential': userCredential,
      'idToken': googleAuth?.idToken,
    };
  }


  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueAccent, Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'MediAlert',
            style: GoogleFonts.lexendDeca(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Sign In/Up for the application',
              style: GoogleFonts.lexendDeca(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () async {
              try {
                final result = await signInWithGoogle();
                final UserCredential userCredential = result['userCredential'];
                final String? idToken = result['idToken'];

                final User? user = userCredential.user;
                Navigator.of(context).push(PageAnimationTransition(page: DashBoard(), pageAnimationType: FadeAnimationTransition()));

                print('Signed in as: ${user?.displayName}');
                print('Access Token: $idToken');
              } on FirebaseAuthException catch (e) {
                // Handle errors
                print(e.code);
              }
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/COxitqgJr1sJnIDe8-jiKhxDx1FrYbtRHKJ9z_hELisAlapwE9LUPh6fcXIfb5vwpbMl4xl9H9TRFPc5NOO8Sb3VSgIBrfRYvW6cUA',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 36),
                Text(
                  'Sign In With Google',
                  style: GoogleFonts.lexendDeca(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                        color: Colors.black
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
          //Lottie.asset('assets/landing2.json', height: 350, width: 350),
        ],
      ),
    );
  }
}