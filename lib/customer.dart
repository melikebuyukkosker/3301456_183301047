import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkshop/customeradd.dart';
import 'package:milkshop/customerinformation.dart';
import 'package:milkshop/customermilk.dart';
import 'package:milkshop/navbar.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "TEDARİKÇİLER",
          ),
        ),
        drawer: const NavDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomerAddPage()));
          },
        ),
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      _musteriRef.snapshots(), //neyi dinledim hangi stream ,
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocumentSnap =
                          asyncSnapshot.data.docs;

                      return ListView.builder(
                          itemCount: listOfDocumentSnap.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Card(
                                color: Colors.white,
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
                                          .collection('sut')
                                          .doc()
                                          .delete();
                                    });
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
                                                builder: (context) => CustomerInformationPage(
                                                    toplamAlacak:
                                                        listOfDocumentSnap[index]
                                                            ['Toplam Alacak'],
                                                    musteriAdi:
                                                        listOfDocumentSnap[index]
                                                            ['Müşteri Adı'],
                                                    musteriAdres:
                                                        listOfDocumentSnap[index]
                                                            ['Müşteri Adres'],
                                                    litreTahmini:
                                                        listOfDocumentSnap[index]
                                                            ['Litre Tahmini'],
                                                    litreFiyati:
                                                        listOfDocumentSnap[
                                                                index]
                                                            ['Litre Fiyatı'],
                                                    id: listOfDocumentSnap[
                                                            index]
                                                        .id)));
                                      },
                                      title: Text(
                                        '${listOfDocumentSnap[index]["Müşteri Adı"]}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircleAvatar(
                                        child: Text(
                                            '${listOfDocumentSnap[index]["Müşteri Adı"][0]}'),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CustomerMilk(
                                                        musteriAdi:
                                                            listOfDocumentSnap[index]
                                                                ['Müşteri Adı'],
                                                        musteriAdres:
                                                            listOfDocumentSnap[index]
                                                                [
                                                                'Müşteri Adres'],
                                                        litreTahmini:
                                                            listOfDocumentSnap[index]
                                                                [
                                                                'Litre Tahmini'],
                                                        litreFiyati:
                                                            listOfDocumentSnap[
                                                                    index][
                                                                'Litre Fiyatı'],
                                                        id: listOfDocumentSnap[index]
                                                            .id)));
                                          },
                                          icon: const Icon(Icons.add))),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Column(
                        children: const [
                          CircularProgressIndicator(),
                          Center(child: Text("yükleniyor"))
                        ],
                      );
                    } //ekrana ne çizmesi gerektiği bilgisi
                  }),
            ),
          ],
        ));
  }
}
