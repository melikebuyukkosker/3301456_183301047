import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milkshop/customer.dart';

class CustomerUpdatePage extends StatefulWidget {
  dynamic id;
  dynamic adiSoyadi;
  String adres;
  int litreFiyati;
  int litreTahmini;
  CustomerUpdatePage(
      {Key? key,
      required this.id,
      required this.adiSoyadi,
      required this.litreFiyati,
      required this.litreTahmini,
      required this.adres})
      : super(key: key);

  @override
  _CustomerUpdatePageState createState() => _CustomerUpdatePageState();
}

class _CustomerUpdatePageState extends State<CustomerUpdatePage> {
  TextEditingController adiSoyadController = TextEditingController();
  TextEditingController adresController = TextEditingController();
  TextEditingController litreFiyatiController = TextEditingController();
  //TextEditingController musteriSirasi = TextEditingController();
  TextEditingController litreTahminiController = TextEditingController();
  dynamic _musteriRef;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _musteriRef = FirebaseFirestore.instance
        .collection('users/${firebaseAuth.currentUser!.uid}/musteri');
    adiSoyadController.text = widget.adiSoyadi;
    adresController.text = widget.adres;
    litreFiyatiController.text = widget.litreFiyati.toString();
    litreTahminiController.text = widget.litreTahmini.toString();
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MİLK SHOP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Güncellendi'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("TEDARİKÇİ GÜNCELLEME"),
      ),
      body: SizedBox(
        width: 500,
        child: Flexible(
          child: Form(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 40)),
                TextFormField(
                  controller: adiSoyadController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.yellow, width: 3),
                          borderRadius: BorderRadius.circular(15)),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.person),
                      labelText: widget.adiSoyadi),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: adresController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.yellow, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.map),
                        labelText: widget.adres),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: litreFiyatiController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.yellow, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person),
                        labelText: widget.litreFiyati.toString()),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 5),
                //   child: TextFormField(
                //     controller: musteriSirasi,
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //         enabledBorder: OutlineInputBorder(
                //             borderSide: const BorderSide(
                //                 color: Colors.yellow, width: 3),
                //             borderRadius: BorderRadius.circular(15)),
                //         filled: true,
                //         fillColor: Colors.white,
                //         prefixIcon: const Icon(Icons.person),
                //         labelText: "Müşteri Sırası"),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: litreTahminiController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.yellow, width: 3),
                            borderRadius: BorderRadius.circular(15)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person),
                        labelText: widget.litreTahmini.toString()),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                        child: const Text('GÜNCELLE'),
                        onPressed: () async {
                          debugPrint(adiSoyadController.text);
                          debugPrint(adresController.text);
                          debugPrint(litreFiyatiController.text);
                          //debugPrint(musteriSirasi.text);
                          debugPrint(litreTahminiController.text);
                          Map<String, dynamic> musteriCol = {
                            'Müşteri Adı': adiSoyadController.text,
                            'Müşteri Adres': adresController.text,
                            'Litre Fiyatı': litreFiyatiController.text,
                            //'Müşteri Sırası': musteriSirasi.text,
                            'Litre Tahmini': litreTahminiController.text,

                            //'sut': litreFiyati.text
                          };

                          await _musteriRef.doc(widget.id).update(musteriCol);

                          _showMyDialog();
                        })),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
