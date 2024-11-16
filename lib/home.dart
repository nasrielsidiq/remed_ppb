import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:remed_ppb/ccoonnection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List listproduct = [];
  Future<void> showProduct() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    final response = await http.get(Uri.parse(MyConnection().getConnection + '/show/produk?token=$token'),
    headers: {
      "ngrok-skip-browser-warning": "true",
    },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        listproduct = jsonResponse['product'];
      });
      log('Berhasil tampil data');
    }
    else{
      log('gagal mendapatkan data: ${response.body}');
    }
  }

  @override
  void initState() {
    showProduct();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color.fromARGB(255, 0, 74, 173),
          Color.fromARGB(255, 83, 145, 226),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
          ),child: Padding(padding: EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Welcome, Salwa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Icon(Icons.person, color: Colors.white, size: 30),
                ],
              ),
              SizedBox(height: 40),
              Container(height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(padding: EdgeInsets.symmetric(
                  horizontal: 8.0),
                  child: TextFormField(obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Cari nama produk....",
                  ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
              itemCount: listproduct.length,
               itemBuilder: (BuildContext context, int index){
                final product = listproduct[index];
                return Card(
                  child: Padding(padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [Image.asset("assets/img.jpg",width: 84, height: 84,),
                    Text(product['name']),
                    Text('Stok:' + product['stok']),
                    ],
                  ),
                  ),
                );
               },
              )),
            ],
          ),
        ),
      )
    );
  }
}
