import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:remed_ppb/ccoonnection.dart';
import 'package:remed_ppb/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
  

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> login() async {
    log('message');
    final request = await http.post(Uri.parse(MyConnection().getConnection + 'login'), body: {
      'nisn': _nisnController.text,
      'password': _passwordController.text
    });
    if (request.statusCode == 200) {
      log('berhasil');
      final response = jsonDecode(request.body);
      final token = response['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHome()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login berhasil")),
      );
    } else {
      log('gagal');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("NISN atau Password salah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 74, 173),
            Color.fromARGB(255, 83, 145, 226),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Logo",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32),
              ),
              SizedBox(height: 80),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _nisnController,
                    autofocus: true,
                    decoration: InputDecoration(hintText: "Masukan NISN"),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Masukan Password",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text("Masuk"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 23, 54, 94),
                      foregroundColor: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}