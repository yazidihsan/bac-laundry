import 'dart:developer';

import 'package:bt_handheld/controllers/util/constants.dart';
import 'package:flutter/services.dart';

class BlueconService {
  static Future<bool?> bluetoothConnect({required String address}) async {
    try {
      final isConnect =
          await platform.invokeMethod<bool>('Connect', {'address': address});

      return isConnect;
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<void> bluetoothDisconnect() async {
    try {
      await platform.invokeMethod('Disconnect');
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }
}
