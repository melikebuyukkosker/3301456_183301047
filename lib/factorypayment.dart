import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class FactoryPaymentPage extends StatefulWidget {
  String id;
  FactoryPaymentPage({Key? key, required this.id}) : super(key: key);

  @override
  _FactoryPaymentPageState createState() => _FactoryPaymentPageState();
}

class _FactoryPaymentPageState extends State<FactoryPaymentPage> {
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
    initializeDateFormatting('tr');
    return Scaffold(
      appBar: AppBar(
        title: const Text("ÖDEMELER"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _fabrikaRef
                .doc(widget.id)
                .collection("Fabrika Ödeme")
                .snapshots(),
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
