import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';

class SignupService {

  Future<Map<String, dynamic>?> signUpWithEmail(
      String name, String email, String password, String idToken) async {
    final url = Uri.parse('https://minorproject-yytm.onrender.com/user/login');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name" : name,
        "email": email,
        "password": password,
        "token": "Bearer $idToken" //Firebase token
      }),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);
    } else {
      print("Signup Failed: ${response.body}");
      return null;
    }
  }
}
