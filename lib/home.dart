import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkshop/navbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic _fabrikaRef;
  dynamic _musteriRef;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String kid = '';
  int sut = 0;
  int toplamSut = 0;
  List<int> fabAlisFiy = [];
  int fabrika = 6;

  @override
  void initState() {
    _fabrikaRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/fabrika');
    _musteriRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "MİLK SHOP",
          style: TextStyle(fontSize: 40),
        )),
      ),
      drawer: const NavDrawer(),
      body: Column(
      children: [
       
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 30, right: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                  ),
                  height: 140,
                  width: 140,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: _musteriRef
                                  .snapshots(), //neyi dinledim hangi stream ,
                              builder: (BuildContext context,
                                  AsyncSnapshot asyncSnapshot) {
                                if (asyncSnapshot.hasData) {
                                  List<DocumentSnapshot> listOfDocumentSnap =
                                      asyncSnapshot.data.docs;
        
                                  return Text(
                                      listOfDocumentSnap.length.toString(),
                                      style: const TextStyle(
                                            fontSize: 60, color: Colors.black));
                                } else {
                                  return Column(
                                    children: const [
                                      CircularProgressIndicator(),
                                      Text("yükleniyor")
                                    ],
                                  );
                                }
                              })),
                      const Text(
                        "Müşteri",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      const Text(
                        " Sayısı",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      )
                    ],
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 30, left: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                  ),
                  height: 140,
                  width: 140,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: _fabrikaRef
                                  .snapshots(), //neyi dinledim hangi stream ,
                              builder: (BuildContext context,
                                  AsyncSnapshot asyncSnapshot) {
                                if (asyncSnapshot.hasData) {
                                  List<DocumentSnapshot> listOfDocumentSnap =
                                      asyncSnapshot.data.docs;
                                  int uzunluk = listOfDocumentSnap.length;
                                  for (var i = 0;
                                      i < listOfDocumentSnap.length;
                                      i++) {
                                    fabAlisFiy.add(int.parse(
                                        listOfDocumentSnap[i]['Alis Fiyati']
                                            .toString()));
                                  }
                                  return Text(uzunluk.toString(),
                                      style: const TextStyle(
                                            fontSize: 60, color: Colors.black));
                                } else {
                                  return Column(
                                    children: const [
                                      CircularProgressIndicator(),
                                      Text("yükleniyor")
                                    ],
                                  );
                                }
                              })),
                      const Text(
                        "Fabrika",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      const Text(
                        " Sayısı",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      )
                    ],
                  ),
                )),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 55),
          child: Text(
            "AYLIK RAPORLAR",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                ),
                height: 230,
                width: 300,
                child: StreamBuilder(
                  stream: _musteriRef.snapshots(),
                  builder: (context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;
                      int totalMilk = 0;
                      int totalAlacak = 0;
                      int totalSiparisKar = 0;
                      int totalSiparis = 0;
        
                      for (DocumentSnapshot currentDoc
                          in listOfDocumentSnap) {
                        totalMilk +=
                            int.parse(currentDoc["Total Süt"].toString());
                        totalAlacak +=
                            int.parse(currentDoc["Toplam Alacak"].toString());
                        totalSiparisKar +=
                            int.parse(currentDoc['Siparis Kar'].toString());
                        totalSiparis += int.parse(
                            currentDoc['Siparis Sayisi'].toString());
                      }
                      debugPrint('Toplam Kar' + totalAlacak.toString());
                      debugPrint("Toplam Süt : $totalMilk");
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "TOPLAM SÜT:       ",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(totalMilk.toString(),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                    const Text(' LİTRE',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black))
                                  ],
                                ),
                              ),
                             
                             
                            
                              
                            ],
                          ),
                        ),
                      );
                    } else if (asyncSnapshot.hasError) {
                      return const Center(
                        child: Text("Hata Oluştu"),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ))),
       ],
         ),
    );
  }
}
