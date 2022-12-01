import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BlePage extends StatefulWidget {
  const BlePage({super.key});

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  bool isScanning = false;
  List<ScanResult> scanResult = [];

  final FlutterBluePlus _fBle = FlutterBluePlus.instance;
  final FlutterBluetoothSerial _fBleSerial = FlutterBluetoothSerial.instance;

  @override
  void initState() {
    super.initState();

    _fBle.isScanning.listen((event) {
      isScanning = event;
      setState(() {});
    });
  }

  void scan() async {
    if (await Permission.bluetoothScan.request().isGranted) {}
    Map<Permission, PermissionStatus> status = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    print(status[Permission.bluetoothScan]);

    if (!isScanning) {
      _fBle.startScan(timeout: Duration(seconds: 5));
      _fBle.scanResults.listen((event) {
        scanResult = event;
        setState(() {});
      });
    } else {
      _fBle.stopScan();
    }
  }

  void pairing(String deviceId) {
    Fluttertoast.showToast(
      msg: deviceId,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.teal.withOpacity(0.3),
      textColor: Colors.black,
    );
  }

  String getDeviceName(ScanResult r) {
    String name;
    if (r.device.name.isEmpty) {
      name = "No Name";
    } else {
      name = r.device.name;
    }

    return name;
  }

  Widget itemList(ScanResult r) {
    return ListTile(
      title: Text(
        getDeviceName(r),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        r.device.id.id,
      ),
      leading: Icon(Icons.devices),
      onTap: () => pairing(getDeviceName(r)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter BLE"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return itemList(scanResult[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: scanResult.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scan(),
        child: Icon(isScanning ? Icons.stop : Icons.bluetooth),
      ),
    );
  }
}
