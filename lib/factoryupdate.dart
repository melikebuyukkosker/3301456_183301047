import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'factory.dart';

class FactoryUpdate extends StatefulWidget {
  String fabrikaAdi;
  String fabrikaAdres;
  String fabrikaAlisFiyati;
  String id;
  FactoryUpdate(
      {Key? key,
      required this.fabrikaAdi,
      required this.fabrikaAdres,
      required this.id,
      required this.fabrikaAlisFiyati})
      : super(key: key);

  @override
  _FactoryUpdateState createState() => _FactoryUpdateState();
}

class _FactoryUpdateState extends State<FactoryUpdate> {
  TextEditingController fabrikaAdiController = TextEditingController();
  TextEditingController fabrikaAdresController = TextEditingController();
  TextEditingController fabrikaFiyatiController = TextEditingController();
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SÜTOP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Güncellendi'),
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
                        builder: (context) => const FactoryPage()));
              },
            ),
          ],
        );
      },
    );
  }

  var _fabrikaRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    fabrikaAdiController.text = widget.fabrikaAdi;
    fabrikaAdresController.text = widget.fabrikaAdres;
    fabrikaFiyatiController.text = widget.fabrikaAlisFiyati;
    _fabrikaRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/fabrika');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FABRİKA GÜNCELLEME"),
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 40)),
            TextFormField(
              controller: fabrikaAdiController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  labelText: widget.fabrikaAdi),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: fabrikaAdresController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: widget.fabrikaAdres),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: fabrikaFiyatiController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: widget.fabrikaAlisFiyati),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                child: const Text("Güncelle"),
                onPressed: () async {
                  //veri tabanına yazdırma
                  //text alanlarındaki veirden bir map oluşturma
                  //veriyi yazmak istediğimiz referans ve ilgili merhot

                  Map<String, dynamic> faktory = {
                    'Fabrika Adi': fabrikaAdiController.text,
                    'Adres': fabrikaAdresController.text,
                    'Alis Fiyati': fabrikaFiyatiController.text
                  };

                  await _fabrikaRef.doc(widget.id).update(faktory);
                  _showMyDialog();
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
