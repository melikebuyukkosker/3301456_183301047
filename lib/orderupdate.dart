import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order.dart';
class OrderUpdatePage extends StatefulWidget {
  String id;
  String urunAdi;
  int urunMiktari;
  int urunAlisFiyati;
  int urunSatisFiyati;
  OrderUpdatePage(
      {Key? key,
      required this.id,
      required this.urunAdi,
      required this.urunMiktari,
      required this.urunSatisFiyati,
      required this.urunAlisFiyati})
      : super(key: key);

  @override
  _OrderUpdatePageState createState() => _OrderUpdatePageState();
}

class _OrderUpdatePageState extends State<OrderUpdatePage> {
  dynamic _urunRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    urunAdiController.text = widget.urunAdi;
    urunMiktariController.text = widget.urunMiktari.toString();
    urunSatisFiyatiConroller.text = widget.urunSatisFiyati.toString();
    urunAlisFiyatiController.text = widget.urunAlisFiyati.toString();
    _urunRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/urun');
    super.initState();
  }

  TextEditingController urunAdiController = TextEditingController();
  TextEditingController urunMiktariController = TextEditingController();
  TextEditingController urunSatisFiyatiConroller = TextEditingController();
  TextEditingController urunAlisFiyatiController = TextEditingController();
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
                  Text('GÜNCELLENDİ'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("ÜRÜN GÜNCELLEME"),
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 40)),
            TextFormField(
              controller: urunAdiController,
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
                controller: urunMiktariController,
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
                controller: urunSatisFiyatiConroller,
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
                controller: urunAlisFiyatiController,
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
                  child: const Text("GÜNCELLE"),
                  onPressed: () async {
                    //veri tabanına yazdırma
                    //text alanlarındaki veirden bir map oluşturma
                    //veriyi yazmak istediğimiz referans ve ilgili merhot
                    if (urunAdiController.text.isNotEmpty &&
                        urunMiktariController.text.isNotEmpty &&
                        urunSatisFiyatiConroller.text.isNotEmpty &&
                        urunAlisFiyatiController.text.isNotEmpty) {
                      debugPrint(urunAdiController.text);
                      debugPrint(urunMiktariController.text);
                      debugPrint(urunSatisFiyatiConroller.text);
                      debugPrint(urunAlisFiyatiController.text);
                      Map<String, dynamic> urunler = {
                        'Urun Adı': urunAdiController.text,
                        'Urun Miktari': int.parse(urunMiktariController.text),
                        'Urun Satıs Fiyati':
                            int.parse(urunSatisFiyatiConroller.text),
                        'Urun Alıs Fiyati':
                            int.parse(urunAlisFiyatiController.text),
                      };

                      await _urunRef.doc(widget.id).update(urunler);
                      _showMyDialog();
                    }
                  },
                )),
          ],
        ),
      )),
    );
  }
}
