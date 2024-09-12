import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueService {
  static final flutterBlue = FlutterBluePlus();

  static Future<void> startScan() async {
    await FlutterBluePlus.startScan();
  }

  static Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }
}
