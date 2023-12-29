import 'package:weather/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'climate.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());
BluetoothDevice? hc05Device;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void initState() {
    super.initState();
    getLocationData();
    startBluetoothScanAndConnect();
  }

  void getLocationData() async {
    var weatherData = await WeatherModel().getlocationWeather();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
      );
    }));
  }

  void startBluetoothScanAndConnect() {
    var condition;
    FlutterBlue flutterBlue = FlutterBlue.instance;
    // Declare the BluetoothDevice variable
    late StreamSubscription<ScanResult> scanSubscription;
    scanSubscription = flutterBlue.scan().listen((ScanResult scanResult) async {
      print("Discovered device: ${scanResult.device.name}");
      // Filter and find the HC-05 device
      if (scanResult.device.name == "HC-05") {
        hc05Device = scanResult.device;
        // Stop the scan once the device is found
        scanSubscription.cancel();
        if (hc05Device != null) {
          // Connect to HC-05
          await hc05Device!.connect();

          // Now you can perform additional actions after the connection
          // For example, send data to Arduino
          sendDataToArduino(hc05Device!, condition);
        } else {
          // Handle the case where hc05Device is null
          print("HC-05 device not found");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWaveSpinner(
          color: Colors.greenAccent,
          size: 100.0,
        ),
      ),
    );
  }
}

late BluetoothCharacteristic characteristic;

void sendDataToArduino(BluetoothDevice? hc05Device, condition) {
  if (hc05Device != null) {
    characteristic.write(utf8.encode(condition));
  } else {
    print("BluetoothDevice is null. Unable to send data to Arduino.");
  }
}
