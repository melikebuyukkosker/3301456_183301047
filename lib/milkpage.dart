import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class MilkPage extends StatefulWidget {
  String id;
  MilkPage({Key? key, required this.id}) : super(key: key);

  @override
  _MilkPageState createState() => _MilkPageState();
}

class _MilkPageState extends State<MilkPage> {
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
        title: const Text("SÜT"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _musteriRef.doc(widget.id).collection("sut").snapshots(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                List<DocumentSnapshot> listOfDocumentSnap =
                    asyncSnapshot.data.docs;
                List<_SalesData> sales = listOfDocumentSnap.map((doc) => _SalesData.fromDocument(doc)).toList();
                return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'SÜT GRAFİĞİ'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: sales,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Süt',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]);
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

class _SalesData {
  _SalesData({required this.year, required this.sales});

  final String year;
  final double sales;


  factory _SalesData.fromDocument(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return _SalesData(
     year : data["Tarih"].toString(),
     sales : data["sut"],
    );
  }
  
}
