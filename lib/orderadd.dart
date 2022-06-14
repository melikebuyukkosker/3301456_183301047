import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order.dart';

class OrderAddPage extends StatefulWidget {
  const OrderAddPage({Key? key}) : super(key: key);

  @override
  _OrderAddPageState createState() => _OrderAddPageState();
}

class _OrderAddPageState extends State<OrderAddPage> {
  dynamic _urunRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _urunRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/urun');
    super.initState();
  }

  TextEditingController urunAd = TextEditingController();
  TextEditingController urunMik = TextEditingController();
  TextEditingController urunSatFiy = TextEditingController();
  TextEditingController urunAlFiy = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  Text('Yeni Ürün Eklendi'),
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
                          builder: (context) => const OrderPage()));
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
                          builder: (context) => const OrderAddPage()));
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ÜRÜN EKLEME"),
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 40)),
            TextFormField(
              controller: urunAd,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Ürün Adı"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: urunMik,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.add_location),
                    labelText: "Ürün Miktari"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: urunSatFiy,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Ürün Satış Fiyati"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: urunAlFiy,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Ürün Alış Fiyati"),
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
                    if (urunAd.text.isNotEmpty &&
                        urunMik.text.isNotEmpty &&
                        urunSatFiy.text.isNotEmpty &&
                        urunAlFiy.text.isNotEmpty) {
                      debugPrint(urunAd.text);
                      debugPrint(urunMik.text);
                      debugPrint(urunSatFiy.text);
                      debugPrint(urunAlFiy.text);
                      Map<String, dynamic> urunler = {
                        'Urun Adı': urunAd.text,
                        'Urun Miktari': int.parse(urunMik.text),
                        'Urun Satıs Fiyati': int.parse(urunSatFiy.text),
                        'Urun Alıs Fiyati': int.parse(urunAlFiy.text),
                      };
                      var urunID = _urunRef.doc();
                      await _urunRef.doc(urunID.id).set(urunler);
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
