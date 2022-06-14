import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class PaymentPage extends StatefulWidget {
  String id;
  int musteriAlacak;
  PaymentPage({Key? key, required this.id, required this.musteriAlacak})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  dynamic _musteriRef;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _musteriRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    return Scaffold(
      appBar: AppBar(
        title: const Text("ÖDEMELER"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _musteriRef.doc(widget.id).collection("Odeme").snapshots(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                List<DocumentSnapshot> listOfDocumentSnap =
                    asyncSnapshot.data.docs;
                return Flexible(
                  child: ListView.builder(
                      itemCount: listOfDocumentSnap.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title:
                                Text('${listOfDocumentSnap[index]['Ödeme']}'),
                            trailing:
                                Text('${listOfDocumentSnap[index]['Tarih']}'),
                            // subtitle:
                            //     Text('${listOfDocumentSnap[index]['Tarih']}'),
                          ),
                        );
                      }),
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
        ],
      ),
    );
  }
}
