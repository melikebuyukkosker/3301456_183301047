import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkshop/home.dart';
import 'package:milkshop/login.dart';
class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool rememberMe = false;
  String name = "";
  String surName = "";
  String email = "";
  String password = "";
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:450.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            color: Colors.yellow,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child:  SizedBox(
                      width: 450.0,
                      child: TextLiquidFill(
                        text: 'MILK SHOP',
                        waveColor: Colors.green,
                        boxBackgroundColor: Colors.yellow,
                        textStyle: const TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                        ),
                        boxHeight: 100.0,
                      ),
                    ),
                        ),
                      ),
                       Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        "assets/images/cow.png",
                        height: 125,
                        width: 125,
                      ),
                    ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        height: 330,
                        width: 350,
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: TextFormField(
                                onSaved: (value) {
                                  name = value!;
                                  debugPrint("{Name: $value}");
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Bu alan boş geçilemez";
                                  }
                                  return null;
                                },
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(Icons.person),
                                    labelText: "Adı "),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: TextFormField(
                                onSaved: (value) {
                                  surName = value!;
                                  debugPrint("{Surname :$value}");
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Bu alan boş geçilemez";
                                  }
                                  return null;
                                },
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(Icons.person),
                                    labelText: "Soyadı"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                onSaved: (value) {
                                  email = value!;
                                  debugPrint("{Email :$value}");
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Bu alan boş geçilemez";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor:
                                        const Color.fromRGBO(7, 74, 102, 1),
                                    hoverColor:
                                        const Color.fromARGB(255, 7, 74, 102),
                                    prefixIcon: const Icon(Icons.mail),
                                    labelText: "E-mail"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 20),
                              child: TextFormField(
                                onSaved: (value) {
                                  password = value!;
                                  debugPrint("{Password :$value}");
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Bu alan boş geçilemez";
                                  }
                                  return null;
                                },
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: "Parola"),
                              ),
                            ),

                            // ),
                            ElevatedButton(
                                onPressed: () async {
                              
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    UserCredential userCredential =
                                        await firebaseAuth
                                            .createUserWithEmailAndPassword(
                                                email: email, password: password);
                                     await firebaseFirestore
                                          .doc(
                                              "users/${userCredential.user!.uid}")
                                          .set({
                                        "name": name,
                                        "surname": surName,
                                        "E-mail": email,
                                        "Password": password
                                      });
                                    Navigator.pop(context);
                                    debugPrint('Butona Basıldı');
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                  } else {
                                    // _showMyDialog();
                                  }
                                },
                                child: const Text("KAYIT OL"),
                                style: ElevatedButton.styleFrom(
                                  
                                    primary: Colors.yellowAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}


