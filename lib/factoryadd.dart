import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'factory.dart';

class FactoryAddPage extends StatefulWidget {
  const FactoryAddPage({Key? key}) : super(key: key);

  @override
  _FactoryAddPageState createState() => _FactoryAddPageState();
}

class _FactoryAddPageState extends State<FactoryAddPage> {
  TextEditingController fabAdiCont = TextEditingController();
  TextEditingController fabAdresCont = TextEditingController();
  TextEditingController fabAlFiyCont = TextEditingController();
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
                Text('Yeni Fabrika Eklendi'),
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

  Future<void> _kshowMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SÜTOP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Lütfen Boş Bırakmayınız!'),
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
                        builder: (context) => const FactoryAddPage()));
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
    _fabrikaRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/fabrika');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FABRİKA EKLEME"),
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 40)),
            TextFormField(
              controller: fabAdiCont,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Fabrika Adı"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: fabAdresCont,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Fabrika Adres"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: fabAlFiyCont,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Fabrika Alış Fiyatı"),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  child: const Text("EKLE"),
                  onPressed: () async {
                    //veri tabanına yazdırma
                    //text alanlarındaki veirden bir map oluşturma
                    //veriyi yazmak istediğimiz referans ve ilgili merhot
                    if (fabAdiCont.text.isNotEmpty &&
                        fabAdresCont.text.isNotEmpty &&
                        fabAlFiyCont.text.isNotEmpty) {
                      debugPrint(fabAdiCont.text);
                      debugPrint(fabAdresCont.text);
                      Map<String, dynamic> faktory = {
                        'Fabrika Adi': fabAdiCont.text,
                        'Adres': fabAdresCont.text,
                        'Alis Fiyati': fabAlFiyCont.text,
                        'Toplam Alacak': 0,
                        'Fabrikadan Toplam Süt': 0,
                      };
                      var factoryID = _fabrikaRef.doc();
                      await _fabrikaRef.doc(factoryID.id).set(faktory);

                      _showMyDialog();
                    } else {
                      _kshowMyDialog();
                    }
                  },
                )),
          ],
        ),
      )),
    );
  }
}
