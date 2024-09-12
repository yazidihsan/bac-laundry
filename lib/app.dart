import 'package:bt_handheld/views/pages/Splash/splash_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Handheld',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const SecondPage(),
      home: const SplashPage(),
    );
  }
}
