import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkshop/customer.dart';

class CustomerAddPage extends StatefulWidget {
  const CustomerAddPage({Key? key}) : super(key: key);

  @override
  _CustomerAddPageState createState() => _CustomerAddPageState();
}

class _CustomerAddPageState extends State<CustomerAddPage> {
  dynamic _musteriRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController adiSoyad = TextEditingController();
  TextEditingController adres = TextEditingController();
  TextEditingController litreFiyati = TextEditingController();
  TextEditingController litreTahmini = TextEditingController();

  @override
  void initState() {
    _musteriRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MİLK SHOP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Yeni Müşteri Eklendi'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerPage()));
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("TEDARİKÇİ EKLEME"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:200.0),
        child: Form(
            child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 40)),
              TextFormField(
                controller: adiSoyad,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.yellow, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Adı-Soyadı"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  controller: adres,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.yellow, width: 3),
                          borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.map),
                      labelText: "Adres"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  controller: litreFiyati,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.yellow, width: 3),
                          borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "      Litre Fiyatı"),
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  controller: litreTahmini,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.yellow, width: 3),
                          borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "      Litre Tahmini"),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: FloatingActionButton(
                      child: const Text('EKLE'),
                      onPressed: () async {
                        debugPrint(adiSoyad.text);
                        debugPrint(adres.text);
                        debugPrint(litreFiyati.text);
                        debugPrint(litreTahmini.text);
                        Map<String, dynamic> musteriCol = {
                          'Müşteri Adı': adiSoyad.text,
                          'Müşteri Adres': adres.text,
                          'Litre Fiyatı': litreFiyati.text,
                          'Litre Tahmini': litreTahmini.text,
                          "Toplam Litre": 0,
                          'Toplam Alacak': 0,
                          "Siparis Kar": 0,
                          "Siparis Sayisi": 0,
                          'Total Süt': 0
                        };
                        var userID = _musteriRef.doc();
                        await _musteriRef.doc(userID.id).set(musteriCol);
                       

                        _showMyDialog();
                      })),
            ],
          ),
        )),
      ),
    );
  }
}
