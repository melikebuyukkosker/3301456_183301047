import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkshop/home.dart';
import 'package:milkshop/record.dart';
//import 'package:sutop1/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  String email = "";
  String password = "";

  Future<void> _showMyDialog(
      {required String ad, required String label}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("MİLK SHOP"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(label),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 450.0),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
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
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 30),
                    //   child: Text(
                    //     "MİLK SHOP",
                    //     style: TextStyle(
                    //       fontSize: 30,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Image.asset(
                        "assets/images/cow.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                      ),
                      height: 200,
                      width: 300,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                email = value;
                                debugPrint("{Email :$value}");
                              },
                              validator: (value) {
                                if (value == "") {
                                  return "Bu alan boş geçilemez";
                                }
                                return null;
                              },
                              // obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(Icons.mail),
                                  labelText: "E-mail"),
                            ),
                            // buildData(label: "Parola", icon: const Icon(Icons.lock),keybord: TextInputType.visiblePassword,deger: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                password = value;
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
                            // buildData(label: "Parola", icon: const Icon(Icons.lock),keybord: TextInputType.visiblePassword,deger: true),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  // ignore: unused_local_variable
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: email, password: password);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                  debugPrint("Butona tıklandı");
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    debugPrint('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    debugPrint(
                                        'Wrong password provided for that user.');
                                  }
                                  _showMyDialog(
                                      ad: "Milk Shop ",
                                      label:
                                          "Kullanıcı adınız veya Parolanız yanlış");
                                }
                              },
                              child: const Text("GİRİŞ"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.white.withOpacity(0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RecordPage()));
                          },
                          child: const Text('KAYIT OL')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
