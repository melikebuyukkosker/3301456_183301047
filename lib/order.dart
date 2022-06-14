import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'navbar.dart';
import 'orderadd.dart';
import 'orderupdate.dart';

//import '../const.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  dynamic _urunRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _urunRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/urun');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ÜRÜNLER"),
      ),
      drawer: const NavDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const OrderAddPage()));
        },
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: _urunRef.snapshots(), //neyi dinledim hangi stream ,
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    List<DocumentSnapshot> listOfDocumentSnap =
                        asyncSnapshot.data.docs;

                    return ListView.builder(
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
                                onDismissed: (director) {
                                  setState(() async {
                                    await listOfDocumentSnap[index]
                                        .reference
                                        .delete();
                                  });
                                },
                                key: Key(
                                  listOfDocumentSnap[index].id,
                                ),
                                child: ExpandablePanel(
                                  header: ListTile(
                                    onTap: () {
                                      debugPrint(
                                          "$index numaralı öğeye tıklandı");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderUpdatePage(
                                                    id: listOfDocumentSnap[
                                                            index]
                                                        .id,
                                                    urunAdi: listOfDocumentSnap[
                                                        index]['Urun Adı'],
                                                    urunMiktari:
                                                        listOfDocumentSnap[
                                                                index]
                                                            ['Urun Miktari'],
                                                    urunSatisFiyati:
                                                        listOfDocumentSnap[
                                                                index][
                                                            'Urun Satıs Fiyati'],
                                                    urunAlisFiyati:
                                                        listOfDocumentSnap[
                                                                index][
                                                            'Urun Alıs Fiyati'],
                                                  )));
                                    },
                                    title: Text(
                                      '${listOfDocumentSnap[index]["Urun Adı"]}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //subtitle: Text(
                                    //    '${listOfDocumentSnap[index]["Urun Miktari"]}'),
                                    leading: CircleAvatar(
                                      child: Text(
                                          '${listOfDocumentSnap[index]["Urun Adı"][0]}'),
                                    ),
                                  ),
                                  expanded: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('Ürün Satış Fiyati  '),
                                            Text(
                                                '${listOfDocumentSnap[index]['Urun Satıs Fiyati']}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Ürün Alış Fiyati  '),
                                            Text(
                                                '${listOfDocumentSnap[index]['Urun Alıs Fiyati']}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  collapsed: const Text(''),
                                ),
                              ),
                            ),
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
    );
  }
}
