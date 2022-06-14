import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'factoryadd.dart';
import 'factoryinformation.dart';
import 'navbar.dart';

//import '../const.dart';

class FactoryPage extends StatefulWidget {
  const FactoryPage({Key? key}) : super(key: key);

  @override
  _FactoryPageState createState() => _FactoryPageState();
}

// List<String> factory = ["FABRIKA ADI SÜT FABRİKASI", "GÜNEY SÜT FABRİKASI"];
// List<String> tarih = ["30.10.2021", "30.11.2021"];
// List<String> circle = ["K", "G"];

class _FactoryPageState extends State<FactoryPage> {
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
    //var _maviRef = _fabrikaRef.doc('mavi');
    return Scaffold(
      appBar: AppBar(
        title: const Text("FABRİKALAR"),
      ),
      drawer: const NavDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FactoryAddPage()));
        },
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _fabrikaRef.snapshots(), //neyi dinledim hangi stream ,
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  List<DocumentSnapshot> listOfDocumentSnap =
                      asyncSnapshot.data.docs;

                  return Flexible(
                    child: ListView.builder(
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              child: Dismissible(
                                  secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    color: Colors.red,
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.delete),
                                    ),
                                  ),
                                  background: Container(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.red,
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.delete),
                                    ),
                                  ),
                                  onDismissed: (director) async {
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                  },
                                  key: Key(
                                    listOfDocumentSnap[index].id,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      debugPrint('-----');
                                      debugPrint(
                                          "$index numaralı öğeye tıklandı");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FactoryInformationPage(
                                                      id: listOfDocumentSnap[
                                                              index]
                                                          .id,
                                                      fabrikaAdi:
                                                          listOfDocumentSnap[
                                                                  index]
                                                              ['Fabrika Adi'],
                                                      fabrikaAdres:
                                                          listOfDocumentSnap[
                                                              index]['Adres'],
                                                      fabrikaAlisFiyati:
                                                          listOfDocumentSnap[
                                                                  index][
                                                              'Alis Fiyati'])));
                                    },
                                    title: Text(
                                      '${listOfDocumentSnap[index]["Fabrika Adi"]}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //subtitle: Text(tarih[index]),
                                    leading: CircleAvatar(
                                      child: Text(
                                          '${listOfDocumentSnap[index]["Fabrika Adi"][0]}'),
                                    ),
                                  )),
                            ),
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("yükleniyor")
                      ],
                    ),
                  );
                } //ekrana ne çizmesi gerektiği bilgisi
              }),
        ],
      ),
    );
  }
}
