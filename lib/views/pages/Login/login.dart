import 'dart:developer';
import 'dart:io';

import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/controllers/theme_manager/space_manager.dart';
import 'package:bt_handheld/controllers/util/shared_pref.dart';
import 'package:bt_handheld/views/common_widgets/custom_button.dart';
import 'package:bt_handheld/views/common_widgets/custom_loading_button.dart';
import 'package:bt_handheld/views/common_widgets/custom_text_field.dart';
import 'package:bt_handheld/views/pages/Home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool _obscureText = true;
  bool isLoading = false;

  String? message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _toggleVisibilty() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  // Future<void> onLogin()async {

  // }

  void onRouteHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> onLogin(String user, String pass) async {
    // Future<void> onScanFetchEvent(String rfid) async {
    // emit(ScanLoading());
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'username': user,
      'password': pass,
    });
    setState(() {
      isLoading = true;
    });

    try {
      final response = await dio.post(
        'https://rfid.indoarsip.co.id/monitoring_rfid/Api/Auth/loginUser',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: formData,
      );

      final data = response.data;

      setState(() {
        message = data['message'].toString();
      });

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        log(data['message'].toString());
        SharedPref pref = SharedPref();
        pref.setAccessToken(data["data"]["token"].toString());
        pref.setUsername(data["data"]["username"].toString());
        pref.setName(data["data"]["nama"].toString());
        pref.setLevel(data["data"]["level"].toString());

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: ColorManager.secondary,
              content: Text(data['message'].toString())),
        );
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        log(data['message'].toString());
        // ignore: use_build_context_synchronously
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       backgroundColor: ColorManager.primary,
        //       content: Text(data['message'].toString())),
        // );
      }
      //     .then((value) {
      //   log('data login :${value.data["message"].toString()}');
      //   String msg = value.data["message"].toString();

      //   // ValueManager.customToast(message);

      //   SharedPref pref = SharedPref();

      //   pref.setAccessToken(value.data["data"]["token"].toString());
      //   pref.setUsername(value.data["data"]["username"].toString());
      //   pref.setName(value.data["data"]["nama"].toString());
      //   pref.setLevel(value.data["data"]["level"].toString());
      //   setState(() {
      //     isLoading = false;
      //     message = msg;
      //   });

      //   // final snackBar = SnackBar(
      //   //   backgroundColor: ColorManager.primary,
      //   //   content: Text('msg.toString()'),
      //   // );
      //   // // ignore: use_build_context_synchronously
      //   log(msg);
      //   if (msg == 'success') {
      //     Navigator.pushReplacement(
      //         // ignore: use_build_context_synchronously
      //         context,
      //         MaterialPageRoute(builder: (context) => const HomePage()));
      //   }

      //   // if (msg == 'success') {
      //   // Navigator.pushReplacement(context,
      //   //     MaterialPageRoute(builder: (context) => const HomePage()));
      //   // } else {
      //   //   final snackBar = SnackBar(
      //   //     backgroundColor: msg == 'success'
      //   //         ? ColorManager.secondary
      //   //         : ColorManager.primary,
      //   //     content: Text(msg.toString()),
      //   //   );
      //   //   // if (value.statusCode == 200) {
      //   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   // }
      //   // log('${pref.getAccessToken()}');

      //   // } else {
      //   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   // }
      //   // if (value.statusCode == 200) {
      //   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   // }
      // }).catchError((error) {
      //   // emit(ScanFailure(errorMessage: error.toString()));
      // });
    } catch (e) {
      log('error:${e.toString()}');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text('User not found or invalid credentials')),
      );
      // if (response?.statusCode == 404) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         backgroundColor: ColorManager.primary,
      //         content: Text(response?.data['message'].toString() ?? 'asuw')),
      //   );
      // } else if (response?.statusCode == 500) {
      // }
      // ignore: use_build_context_synchronously
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.0.spaceY,
              const Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              48.0.spaceY,
              CustomTextField(controller: userController, title: "Username"),
              16.0.spaceY,
              CustomTextField(
                controller: passController,
                title: "Password",
                obscureText: _obscureText,
                suffixIcon: IconButton(
                    onPressed: _toggleVisibilty,
                    icon: Icon(_obscureText
                        ? Icons.visibility_off
                        : Icons.visibility)),
              ),
              38.0.spaceY,
              // isLoading
              //     ? const Center(child: CustomLoadingButton())
              //     :
              isLoading == true
                  ? const Center(child: CustomLoadingButton())
                  : CustomButton(
                      onPressed: () {
                        if (userController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: ColorManager.primary,
                                content: const Text('user anda belum diisi!')),
                          );
                          return;
                        }
                        if (passController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: ColorManager.primary,
                                content:
                                    const Text('password anda belum diisi!')),
                          );
                          return;
                        }

                        onLogin(userController.text, passController.text);
                      },
                      title: "Login")

              // FutureBuilder(
              //     future: onLogin(userController.text, passController.text),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Center(
              //           child: CustomLoadingButton(),
              //         ); // while waiting for the future
              //       } else if (snapshot.hasError) {
              //         // return SnackBar(content: Text(message.toString()));
              //         // return Text('Error: ${snapshot.error}');
              //         final snackBar = SnackBar(
              //             backgroundColor: ColorManager.secondary,
              //             content: Text(snapshot.error.toString()));
              //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //       } else if (snapshot.hasData) {
              //         Navi
              //       }
              //       return CustomButton(
              //           onPressed: () {
              //             onLogin(userController.text, passController.text);
              //           },
              //           title: "Login");
              //     })
            ],
          ),
        ),
      ),
    );
  }
}
