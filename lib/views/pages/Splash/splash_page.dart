import 'dart:async';

import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/controllers/util/shared_pref.dart';
import 'package:bt_handheld/views/pages/Home/home_page.dart';
import 'package:bt_handheld/views/pages/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? _token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPref pref = SharedPref();
    pref.getAccessToken().then((value) => setState(() {
          _token = value;
        }));

    Timer(Duration(seconds: 3), () {
      if (_token == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            'assets/indoarsiplogo.png',
            width: 150,
            height: 150,
          )),
          const SizedBox(
            height: 24,
          ),
          LoadingAnimationWidget.staggeredDotsWave(
              color: ColorManager.primary, size: 50)
        ],
      ),
    );
  }
}
