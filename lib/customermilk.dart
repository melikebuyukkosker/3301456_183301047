import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'customer.dart';

// ignore: must_be_immutable
class CustomerMilk extends StatefulWidget {
  String musteriAdi;
  String musteriAdres;
  // String musteriSirasi;
  String litreTahmini;
  String litreFiyati;
  String id;
  CustomerMilk(
      {Key? key,
      required this.id,
      required this.musteriAdi,
      required this.musteriAdres,
      // required this.musteriSirasi,
      required this.litreFiyati,
      required this.litreTahmini})
      : super(key: key);

  @override
  State<CustomerMilk> createState() => _CustomerMilkState();
}

// todayDate() {
//   var now = new DateTime.now();
//   var formatter = new DateFormat('dd-MM-yyyy');
//  // String formattedTime = DateFormat('kk:mm:a').format(now);
//   String formattedDate = formatter.format(now);
//   //debugPrint(formattedTime);
//   debugPrint(formattedDate);
// }

class _CustomerMilkState extends State<CustomerMilk> {
  TextEditingController ksut = TextEditingController();
  List<int> counts = [];
  List<String> siparisAdi = [];
  List<int> siparisMik = [];
  List<int> urunSatisFiyati = [];
  List<int> urunAlisFiyati = [];
  int klength = 0;
  String formattedTime = '';
  var _musteriRef;
  var _urunRef;
  var _fabrikaRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void initState() {
    ksut.text = "0";
    _musteriRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');
    _urunRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/urun');
    _fabrikaRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/fabrika');
    super.initState();
  }

  @override
  void _increment(int index) {
    setState(() {
      counts[index]++;
      debugPrint(counts[index].toString());
    });
  }

  void _dicrement(int index) {
    setState(() {
      if (counts[index] > 0) {
        counts[index]--;
        debugPrint(counts[index].toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    @override
    int sut = 0;
    int toplamSut = 0;
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
                  Text(' Eklendi'),
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

    void _ekle(int index) async {
      if (siparisMik[index] > 0) {
        Map<String, dynamic> siparis = {
          'Urun Adı': siparisAdi[index],
          'Urun Miktari': siparisMik[index],
          'Tarih': formattedTime
        };
        await _musteriRef
            .doc(widget.id)
            .collection("siparis")
            .doc()
            .set(siparis);
      }
      _showMyDialog();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("SİPARİŞ EKLEME"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('EKLE'),
        onPressed: () async {
          //debugPrint(todayDate());
          DateTime now = DateTime.now();
          formattedTime = DateFormat('dd-MM-yyyy kk:mm:a').format(now);
          sut = int.parse(ksut.text);
          // debugPrint(toplamSut.toString());
          toplamSut = toplamSut + sut;
          debugPrint(widget.id);
          Map<String, dynamic> sutId = {'sut': sut, 'Tarih': formattedTime};
          int toplamAlacak =
              toplamSut * int.parse(widget.litreFiyati.toString());

          // Map<String, dynamic> toplamSutID = {'Toplam Sut': toplamSut};
          await _musteriRef.doc(widget.id).collection("sut").doc().set(sutId);
          await _musteriRef
              .doc(widget.id)
              .update({"Toplam Litre": FieldValue.increment(sut)});
          await _musteriRef
              .doc(widget.id)
              .update({"Total Süt": FieldValue.increment(sut)});

          await _musteriRef
              .doc(widget.id)
              .update({"Toplam Alacak": FieldValue.increment(toplamAlacak)});

          for (int index = 0; index < klength; index++) {
            _ekle(index);
            await _musteriRef.doc(widget.id).update({
              "Toplam Alacak": FieldValue.increment(
                  -(urunSatisFiyati)[index] * siparisMik[index])
            });
            await _musteriRef.doc(widget.id).update({
              "Siparis Kar": FieldValue.increment(
                  ((urunSatisFiyati)[index] * siparisMik[index]) -
                      ((urunAlisFiyati)[index] * siparisMik[index]))
            });
            await _musteriRef.doc(widget.id).update(
                {"Siparis Sayisi": FieldValue.increment(siparisMik[index])});
          }
        },
      ),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 60, left: 60),
              child: TextFormField(
                controller: ksut,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.white,
                    // prefixIcon: const Icon(Icons.add_a_photo),
                    labelText: "Sut"),
              ),
            ),
            // ElevatedButton(
            //     child: const Text('Süt '),
            //     onPressed: () async {
            //       //debugPrint(todayDate());
            //       DateTime now = DateTime.now();
            //       String formattedTime =
            //           DateFormat('dd-MM-yyyy kk:mm:a').format(now);
            //       sut = int.parse(_sut.text);
            //       // debugPrint(toplamSut.toString());
            //       toplamSut = toplamSut + sut;
            //       debugPrint(widget.id);
            //       Map<String, dynamic> sutId = {
            //         'sut': sut,
            //         'Tarih': formattedTime
            //       };

            //       // Map<String, dynamic> toplamSutID = {'Toplam Sut': toplamSut};
            //       await _musteriRef
            //           .doc(widget.id)
            //           .collection("sut")
            //           .doc()
            //           .set(sutId);
            //       // await _musteriRef
            //       //     .doc(widget.id)
            //       //     .collection("toplamSut")
            //       //     .doc("sut")
            //       //     .set(toplamSutID);

            //       //debugPrint(toplamSut.toString());
            //     }),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _urunRef.snapshots(), // neyi dinledim hangi stream ,
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;

                      return ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            klength = listOfDocumentSnap.length;
                            for (var i = 0;
                                i < listOfDocumentSnap.length;
                                i++) {
                              siparisAdi.add(listOfDocumentSnap[i]['Urun Adı']);
                              urunSatisFiyati.add(
                                  listOfDocumentSnap[i]["Urun Satıs Fiyati"]);
                              urunAlisFiyati.add(
                                  listOfDocumentSnap[i]["Urun Alıs Fiyati"]);
                              siparisMik.add(0);
                              counts.add(0);
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Card(
                                  child: ExpandablePanel(
                                header: ListTile(
                                  onTap: () {
                                    debugPrint(
                                        "$index numaralı öğeye tıklandı");
                                  },
                                  title: Text(
                                    '${listOfDocumentSnap[index]["Urun Adı"]}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text(
                                  //     '${listOfDocumentSnap[index]["Urun Miktari"]}'),
                                  leading: CircleAvatar(
                                    child: Text(
                                        '${listOfDocumentSnap[index]["Urun Adı"][0]}'),
                                  ),
                                ),
                                expanded: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(counts[index].toString()),
                                    const Text("   Tane Sipariş Eklendi")
                                  ],
                                ),
                                collapsed: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _increment(index);

                                          siparisMik[index] = counts[index];
                                          debugPrint("$index butona tıklandı");
                                          debugPrint(
                                              '${siparisAdi[index]},${siparisMik[index]}');
                                          //_ekle(index);
                                        },
                                        icon: const Icon(Icons.add)),
                                    Text(counts[index].toString()),
                                    IconButton(
                                        onPressed: () {
                                          _dicrement(index);

                                          siparisMik[index] = counts[index];
                                          debugPrint("$index butona tıklandı");
                                          debugPrint('${siparisMik[index]}');
                                          debugPrint(
                                              '${siparisAdi[index]},${siparisMik[index]}');
                                          // _ekle(index);
                                        },
                                        icon: const Icon(Icons.remove)),
                                    // ElevatedButton(
                                    //     child: const Text("Siparis Ekle"),
                                    //     onPressed: () {
                                    //       Map<String, dynamic> sirapisCol = {
                                    //         'Urun Adı':
                                    //             listOfDocumentSnap[index]
                                    //                 ["Urun Adı"],
                                    //         'Urun Miktari': _currentCount
                                    //       };
                                    //       FirebaseFirestore.instance
                                    //           .collection("musteri")
                                    //           .doc(widget.id)
                                    //           .collection("siparis")
                                    //           .doc()
                                    //           .set(sirapisCol);
                                    //     })
                                  ],
                                ),
                              )),
                            );
                          });
                    } else {
                      return Column(
                        children: const [
                          CircularProgressIndicator(),
                          Text("yükleniyor")
                        ],
                      );
                    } //ekrana ne çizmesi gerektiği bilgisi
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
