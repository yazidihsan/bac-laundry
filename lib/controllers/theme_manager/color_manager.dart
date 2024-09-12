import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex('#ed1e24');
  static Color secondary = HexColor.fromHex('#11a832');
  static Color failFlushbar = HexColor.fromHex('#E74C3C');
  static Color successFlushbar = HexColor.fromHex('#4CAF50');
  // static Color darkGrey = HexColor.fromHex('#7A7A7A');
  // static Color grey = HexColor.fromHex('#E7E7E7');
  // static Color revision = HexColor.fromHex('#FFC107');
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }

    return Color(int.parse(hexColorString, radix: 16));
  }
}
