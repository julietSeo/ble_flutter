import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  bool isScanning = false;
  List<BluetoothDevice> bondedDevice = [];

  final FlutterBluetoothSerial _fBleSerial = FlutterBluetoothSerial.instance;

  static const MethodChannel _channel =
      MethodChannel('com.example.ble_flutter');

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<List<BluetoothDevice>> getBondedDevices() async {
    final List devices = await _channel.invokeMethod('getBondedDevices');
    setState(() {
      bondedDevice = devices.map((e) => BluetoothDevice.fromMap(e)).toList();
      print(bondedDevice[0].address);
    });

    return devices.map((map) => BluetoothDevice.fromMap(map)).toList();
  }

  void init() async {
    if (await Permission.bluetoothScan.request().isGranted) {}
    Map<Permission, PermissionStatus> status = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
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

  String getDeviceName(BluetoothDevice d) {
    return d.name!;
  }

  Widget itemList(BluetoothDevice d) {
    return ListTile(
      title: Text(
        d.name!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        d.address,
      ),
      leading: Icon(Icons.devices),
      onTap: () => pairing(getDeviceName(d)),
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
            return itemList(bondedDevice[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemCount: bondedDevice.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getBondedDevices();
        },
        child: Icon(isScanning ? Icons.stop : Icons.bluetooth),
      ),
    );
  }
}
