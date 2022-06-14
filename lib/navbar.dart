import 'package:flutter/material.dart';
import 'package:milkshop/customer.dart';
import 'package:milkshop/factory.dart';
import 'package:milkshop/grafikk.dart';
import 'package:milkshop/home.dart';
import 'package:milkshop/login.dart';
import 'package:milkshop/order.dart';
import 'package:milkshop/screens/home_screen.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MILK SHOP'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Çıkmak istediğinize emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                children: [
                  TextButton(
                    child: const Text('EVET'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                  ),
                  TextButton(
                    child: const Text('HAYIR'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                '',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage('assets/images/cow.png'))),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text('Anasayfa'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  HomePage()))
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('Tedarikçi'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerPage()))
              },
            ),
             ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('FABRİKALAR'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FactoryPage()))
              },
            ),
             ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('Ürünler'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderPage()))
              },
            ),
              ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text('Hava Durumu'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()))
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış'),
              onTap: () => {_showMyDialog()},
            ),
          ],
        ),
      ),
    );
  }
}
