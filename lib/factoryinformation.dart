import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'factorypayment.dart';
import 'factoryupdate.dart';

// ignore: must_be_immutable
class FactoryInformationPage extends StatefulWidget {
  String fabrikaAdi;
  String fabrikaAdres;
  String fabrikaAlisFiyati;
  String id;

  FactoryInformationPage(
      {Key? key,
      required this.fabrikaAlisFiyati,
      required this.fabrikaAdi,
      required this.fabrikaAdres,
      required this.id})
      : super(key: key);

  @override
  State<FactoryInformationPage> createState() => _FactoryInformationPageState();
}

class _FactoryInformationPageState extends State<FactoryInformationPage> {
  CollectionReference<Map<String, dynamic>>? _fabrikaRef;
  CollectionReference<Map<String, dynamic>>? _musteriRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String formattedTime = '';
  int fabrikaAlacak = 0;
  int ftotalSut = 0;
  @override
  void initState() {
    _fabrikaRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/fabrika');
    _musteriRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');
    super.initState();
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FactoryUpdate(
                  id: widget.id,
                  fabrikaAdi: widget.fabrikaAdi,
                  fabrikaAdres: widget.fabrikaAdres,
                  fabrikaAlisFiyati: widget.fabrikaAlisFiyati,
                )));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FactoryPaymentPage(
                  id: widget.id,
                )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FABRİKA BİLGİSİ'),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    const PopupMenuItem(value: 0, child: Text('Düzenle')),
                    const PopupMenuItem(
                        value: 1, child: Text('Fabrika Alınanlar'))
                  ])
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: _musteriRef!.snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> listOfDocumentSnap =
                            asyncSnapshot.data.docs;

                        for (DocumentSnapshot currentDoc
                            in listOfDocumentSnap) {
                          ftotalSut +=
                              int.parse(currentDoc["Total Süt"].toString());
                        }

                        fabrikaAlacak =
                            ftotalSut * int.parse(widget.fabrikaAlisFiyati);
                        debugPrint(ftotalSut.toString());
                        debugPrint(fabrikaAlacak.toString());
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                              0
                                                  .toString() //ftotalSut.toString()
                                              ,
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
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                            0 //fabrikaAlacak
                                                .toString(),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: const [
                            CircularProgressIndicator(),
                            Center(child: Text("yükleniyor"))
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                      title: const Text('FABRİKA ADI'),
                      subtitle: Row(
                        children: [Text(widget.fabrikaAdi)],
                      )),
                ),
                Card(
                  child: ListTile(
                      title: const Text('FABRİKA ADRESİ'),
                      subtitle: Row(
                        children: [Text(widget.fabrikaAdres)],
                      )),
                ),
                Card(
                  child: ListTile(
                      title: const Text('FABRİKA ALIŞ FİYATI'),
                      subtitle: Row(
                        children: [Text(widget.fabrikaAlisFiyati)],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _fabrikaRef!.doc(widget.id).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ElevatedButton(
                              onPressed: fabrikaAlacak < 0
                                  ? () async {
                                      debugPrint(ftotalSut.toString());
                                      DateTime now = DateTime.now();
                                      formattedTime =
                                          DateFormat('dd-MM-yyyy kk:mm:a')
                                              .format(now);
                                      Map<String, dynamic> odeGec = {
                                        'Ödeme': fabrikaAlacak,
                                        'Tarih': formattedTime
                                      };

                                      await _fabrikaRef!
                                          .doc(widget.id)
                                          .collection('Fabrika Ödeme')
                                          .doc()
                                          .set(odeGec);
                                      setState(() async {
                                        await _fabrikaRef!
                                            .doc(widget.id)
                                            .update({"Toplam Süt": 0});

                                        // await _fabrikaRef!
                                        //     .doc(widget.id)
                                        //     .update({
                                        //   "Kalıcı Toplam Alacak": fabrikaAlacak
                                        // });
                                        await _fabrikaRef!
                                            .doc(widget.id)
                                            .update({
                                          "Toplam Alacak": fabrikaAlacak
                                        });
                                      });
                                    }
                                  : null,
                              child: Text(
                                  fabrikaAlacak < 0 ? 'ÖDENMEDİ' : 'ÖDENDİ'));
                        } else if (snapshot.hasError) {
                          return const Text('Bir hata oluştu');
                        }
                        return const Center(
                          child: ElevatedButton(
                              onPressed: null,
                              child: CircularProgressIndicator()),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
