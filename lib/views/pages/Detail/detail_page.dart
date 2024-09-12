import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bt_handheld/controllers/bloc/blue_bloc.dart';
import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/models/bluetooth.dart';
import 'package:bt_handheld/views/common_widgets/custom_button.dart';
import 'package:bt_handheld/views/pages/Home/home_page.dart';
import 'package:bt_handheld/controllers/services/bluecon_service.dart';
import 'package:bt_handheld/controllers/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final bluetoothBloc = BlueBloc();

  bool scanning = false;
  bool connected = false;

  StreamSubscription? keySubscription;

  _searchDevices() {
    if (scanning) {
      keySubscription?.cancel();
      log('Stop Search BT Devices');
    } else {
      keySubscription = keyChannel.receiveBroadcastStream().listen((event) {
        final jsonString = jsonEncode(event);
        final data = jsonDecode(jsonString);
        final bluetooth = Bluetooth.fromJson(data);
        bluetoothBloc.add(AddBluetooth(bluetooth: bluetooth));
        log(event.toString());
      });
      log('Start Search BT Devices');
    }
    setState(() {
      scanning = !scanning;
    });
  }

  @override
  void dispose() {
    bluetoothBloc.close();
    keySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Handheld'),
      ),
      body: BlocProvider(
        create: (context) => bluetoothBloc,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 64.0),
                child: CustomButton(
                  backgroundColor: ColorManager.primary,
                  onPressed: _searchDevices,
                  title:
                      scanning ? 'Stop Search Devices' : 'Start Search Devices',
                ),
              ),
              BlocBuilder<BlueBloc, BlueState>(
                builder: (context, bluetoothState) {
                  final bluetooths = bluetoothState.bluetooths;

                  return Column(
                    children: [
                      // Text('${bluetooths.length}'),
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: bluetooths.length,
                        itemBuilder: (context, index) {
                          final bluetooth = bluetooths[index];

                          // return Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Column(
                          //       children: [
                          //         Text(bluetooth.name ?? '-'),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Text(bluetooth.address ?? '-'),
                          //       ],
                          //     ),
                          //     TextButton(
                          //         style: TextButton.styleFrom(
                          //           backgroundColor: connected
                          //               ? Colors.black26
                          //               : Colors.black,
                          //         ),
                          //         onPressed: () async {
                          //           if (connected == false) {
                          //             BlueconService.bluetoothConnect(
                          //                     address: bluetooth.address ?? '')
                          //                 .then((isConnect) {
                          //               if (isConnect ?? false) {
                          //                 keySubscription
                          //                     .cancel()
                          //                     .then((value) {
                          //                   setState(() {
                          //                     connected = !connected;
                          //                   });
                          //                 });
                          //               }
                          //               log('isConnect: $isConnect');
                          //             });
                          //           } else {
                          //             BlueconService.bluetoothDisconnect();
                          //           }
                          //         },
                          //         child: Center(
                          //           child: Text(
                          //             connected ? "disconnect" : "connect",
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         ))
                          //   ],
                          // );

                          return ListTile(
                            title: Text(bluetooth.name ?? '-'),
                            subtitle: Text(bluetooth.address ?? '-'),
                            onTap: () async {
                              BlueconService.bluetoothConnect(
                                      address: bluetooth.address ?? '')
                                  .then((isConnect) {
                                if (isConnect ?? false) {
                                  keySubscription?.cancel().then((value) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ));
                                  });
                                }
                                log('isConnect: $isConnect');
                              });
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
