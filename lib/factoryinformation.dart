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
        title: const Text('FABR??KA B??LG??S??'),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    const PopupMenuItem(value: 0, child: Text('D??zenle')),
                    const PopupMenuItem(
                        value: 1, child: Text('Fabrika Al??nanlar'))
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
                              int.parse(currentDoc["Total S??t"].toString());
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
                                          child: Text("L??TRE",
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
                                        child: Text("L??TRE",
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
                            Center(child: Text("y??kleniyor"))
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
                      title: const Text('FABR??KA ADI'),
                      subtitle: Row(
                        children: [Text(widget.fabrikaAdi)],
                      )),
                ),
                Card(
                  child: ListTile(
                      title: const Text('FABR??KA ADRES??'),
                      subtitle: Row(
                        children: [Text(widget.fabrikaAdres)],
                      )),
                ),
                Card(
                  child: ListTile(
                      title: const Text('FABR??KA ALI?? F??YATI'),
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
                                        '??deme': fabrikaAlacak,
                                        'Tarih': formattedTime
                                      };

                                      await _fabrikaRef!
                                          .doc(widget.id)
                                          .collection('Fabrika ??deme')
                                          .doc()
                                          .set(odeGec);
                                      setState(() async {
                                        await _fabrikaRef!
                                            .doc(widget.id)
                                            .update({"Toplam S??t": 0});

                                        // await _fabrikaRef!
                                        //     .doc(widget.id)
                                        //     .update({
                                        //   "Kal??c?? Toplam Alacak": fabrikaAlacak
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
                                  fabrikaAlacak < 0 ? '??DENMED??' : '??DEND??'));
                        } else if (snapshot.hasError) {
                          return const Text('Bir hata olu??tu');
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
