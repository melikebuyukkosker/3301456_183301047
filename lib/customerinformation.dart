import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milkshop/milkpage.dart';
import 'package:milkshop/order.dart';
import 'package:milkshop/paymentpage.dart';

import 'customerupdate.dart';
// ignore: must_be_immutable
class CustomerInformationPage extends StatefulWidget {
  String musteriAdi;
  String musteriAdres;
  String litreTahmini;
  String litreFiyati;
  String id;
  int toplamAlacak;
  int toplamSut = 0;

  CustomerInformationPage(
      {Key? key,
      required this.musteriAdi,
      required this.musteriAdres,
      required this.litreFiyati,
      required this.litreTahmini,
      required this.toplamAlacak,
      required this.id})
      : super(key: key);

  @override
  State<CustomerInformationPage> createState() =>
      _CustomerInformationPageState();
}

class _CustomerInformationPageState extends State<CustomerInformationPage> {
  int sut = 0;
  List<int> customerMilk = [];
  int customerAdd = 0;
  String formattedTime = '';
  CollectionReference<Map<String, dynamic>>? _musteriref;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _musteriref = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');

    super.initState();
  }

  void onSelected(BuildContext context, int item) {
      switch (item) {
      case 0:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MilkPage(id: widget.id)));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const OrderPage()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CustomerUpdatePage(
                  id: widget.id,
                  adiSoyadi: widget.musteriAdi,
                  litreFiyati: int.parse(widget.litreFiyati.toString()),
                  litreTahmini: int.parse(widget.litreTahmini.toString()),
                  adres: widget.musteriAdres,
                )));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentPage(
                  id: widget.id,
                  musteriAlacak: widget.toplamAlacak,
                )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.musteriAdi),
         actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    const PopupMenuItem(value: 0, child: Text('Süt Listesi')),
                    const PopupMenuItem(
                        value: 1, child: Text('Sipariş Listesi')),
                    const PopupMenuItem(value: 2, child: Text('Düzenle')),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Ödemeler'),
                    )
                  ])
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            StreamBuilder(
              stream: _musteriref!.doc(widget.id).collection("sut").snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  List<DocumentSnapshot> listOfDocumentSnap =
                      asyncSnapshot.data.docs;
                  for (int i = 0; i < listOfDocumentSnap.length; i++) {
                    sut = int.parse(listOfDocumentSnap[i]['sut'].toString());

                    widget.toplamSut += sut;
                  }
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: _musteriref!.doc(widget.id).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String toplamSut =
                                      snapshot.data!["Toplam Litre"].toString();
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(toplamSut,
                                            style: const TextStyle(
                                                fontSize: 60,
                                                color: Colors.white)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 15),
                                        child: Text("LİTRE",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white)),
                                      )
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  Column(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text("Error",
                                            style: TextStyle(
                                                fontSize: 60,
                                                color: Colors.white)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 15),
                                        child: Text("TL",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white)),
                                      )
                                    ],
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                        ),
                        Container(
                          child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: _musteriref!.doc(widget.id).snapshots(),
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.hasData) {
                                  String toplamAlacak = asyncSnapshot
                                      .data!["Toplam Alacak"]
                                      .toString();

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(toplamAlacak,
                                            style: const TextStyle(
                                                fontSize: 60,
                                                color: Colors.white)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 15),
                                        child: Text("TL",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white)),
                                      )
                                    ],
                                  );
                                } else if (asyncSnapshot.hasError) {
                                  return Column(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text("Null",
                                            style: TextStyle(
                                                fontSize: 60,
                                                color: Colors.white)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 15),
                                        child: Text("ALACAK",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white)),
                                      )
                                    ],
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: const [
                      CircularProgressIndicator(),
                      Center(child: Text("yükleniyor"))
                    ],
                  );
                }
              },
            ),
            Flexible(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                        title: const Text('MÜŞTERİ ADRES'),
                        subtitle: Text(widget.musteriAdres)),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text('LİTRE FİYATI'),
                        subtitle: Row(
                          children: [
                            Text(widget.litreFiyati),
                            const Text('  KURUŞ')
                          ],
                        )),
                  ),
                  Card(
                    child: ListTile(
                        title: const Text('LİTRE TAHMİNİ'),
                        subtitle: Row(
                          children: [
                            Text(widget.litreTahmini),
                            const Text('   LİTRE')
                          ],
                        )),
                  ),
                ],
              ),
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _musteriref!.doc(widget.id).snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    int toplamAlacak = asyncSnapshot.data!["Toplam Alacak"];

                    return ElevatedButton(
                        onPressed: toplamAlacak > 0
                            ? () async {
                                DateTime now = DateTime.now();
                                formattedTime = DateFormat('dd-MM-yyyy kk:mm:a')
                                    .format(now);
                                Map<String, dynamic> odeGec = {
                                  'Ödeme': widget.toplamAlacak,
                                  'Tarih': formattedTime
                                };
                                await _musteriref!
                                    .doc(widget.id)
                                    .collection('Odeme')
                                    .doc()
                                    .set(odeGec);
                                setState(() async {
                                  await _musteriref!
                                      .doc(widget.id)
                                      .update({"Toplam Alacak": 0});
                                  await _musteriref!
                                      .doc(widget.id)
                                      .update({"Toplam Litre": 0});
                                });
                              }
                            : null,
                        child: Text(toplamAlacak > 0 ? 'ÖDENMEDİ' : "ÖDENDİ"));
                  } else if (asyncSnapshot.hasError) {
                    return const Text("Bir Hata Oluştu");
                  }
                  return const Center(
                    child: ElevatedButton(
                        onPressed: null, child: CircularProgressIndicator()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
