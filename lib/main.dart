import 'package:ble_flutter/bluetoothpage.dart';
import 'package:flutter/material.dart';

import 'blepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FunList(),
    );
  }
}

class FunList extends StatelessWidget {
  const FunList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Flutter Example"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "01 BlePage",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => BlePage())),
            ),
            ListTile(
              title: Text(
                "02 BluetoothPage",
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => BluetoothPage())),
            )
          ],
        ),
      ),
    );
  }
}
