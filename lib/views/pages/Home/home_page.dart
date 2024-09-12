import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/controllers/util/shared_pref.dart';
import 'package:bt_handheld/views/pages/Home/widget/card.dart';
import 'package:bt_handheld/views/pages/Detail/detail_page.dart';
import 'package:bt_handheld/views/pages/Login/login.dart';
import 'package:bt_handheld/views/pages/Rack/rack.dart';
import 'package:bt_handheld/views/pages/Rfid/rfid_page.dart';
import 'package:bt_handheld/views/pages/Search/search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<ActivitiesData> activitesData = [
  ActivitiesData(id: 1, name: "RECEIVED", icon: icons[0]),
  ActivitiesData(id: 2, name: "FUMIGASI-IN", icon: icons[1]),
  ActivitiesData(id: 3, name: "FUMIGASI-OUT", icon: icons[2]),
  ActivitiesData(id: 4, name: "STORAGE", icon: icons[3]),
  ActivitiesData(id: 5, name: "DELIVERY", icon: icons[4]),
  ActivitiesData(id: 6, name: "STOCK OPNAME", icon: icons[5]),
  ActivitiesData(id: 7, name: "SEARCH", icon: icons[6]),
];

List<Widget> icons = [
  const Icon(
    Icons.access_alarm,
    size: 50,
    color: Colors.white,
  ),
  const Icon(
    Icons.baby_changing_station,
    size: 50,
    color: Colors.white,
  ),
  const Icon(
    Icons.dangerous,
    size: 50,
    color: Colors.white,
  ),
  const Icon(
    Icons.cabin,
    size: 50,
    color: Colors.white,
  ),
  const Icon(
    Icons.delivery_dining,
    size: 50,
    color: Colors.white,
  ),
  const Icon(
    Icons.warehouse,
    size: 50,
    color: Colors.white,
  ),
  const Icon(
    Icons.search,
    size: 50,
    color: Colors.white,
  ),
];

class _HomePageState extends State<HomePage> {
  String username = '';
  // Completer<void>? _completer;

  @override
  void initState() {
    // TODO: implement initState
    // _completer = Completer<void>();
    SharedPref pref = SharedPref();
    pref.getAccessToken().then((value) => log('token : ${value}'));

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Your code here, e.g., showing a SnackBar

    //   if (_completer != null) {
    //     if (!_completer!.isCompleted && mounted) {
    //       final snackBar = SnackBar(
    //         backgroundColor: ColorManager.secondary,
    //         content: Text('Selamat Datang!'),
    //       );

    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     }
    //   }
    // }
    // );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _completer?.complete();
    super.dispose();
  }

  // Widget _fetchActivities(List<Activities> activities) => Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //       child: Wrap(
  //           runSpacing: 8.0,
  //           spacing: 8.0,
  //           children: activities.map((data) {
  //             var iconData = data.icon;
  //             int index = activities.indexOf(data);

  //             iconData = icons[index];
  //             return CardWidget(
  //               onTap: () {
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return RfidPage(
  //                       id: int.parse(data.id.toString()),
  //                       name: data.name.toString());
  //                 }));
  //               },
  //               title: "${data.name}",
  //               icon: iconData,
  //             );
  //           }).toList()),
  //     );

  Future<void> onLogout() async {
    // Future<void> onScanFetchEvent(String rfid) async {
    // emit(ScanLoading());
    var dio = Dio();

    try {
      await dio
          .post(
        'https://rfid.indoarsip.co.id/monitoring_rfid/Api/Auth/logoutUser',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      )
          .then((value) {
        log('data logout :${value.data["message"].toString()}');

        // ValueManager.customToast(message);

        SharedPref pref = SharedPref();

        pref.clearAccessToken();
        pref.clearUsername();
        pref.clearName();
        pref.clearLevel();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
        // log('${pref.getAccessToken()}');

        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
        // if (value.statusCode == 200) {
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
      }).catchError((error) {
        // emit(ScanFailure(errorMessage: error.toString()));
      });
    } catch (e) {
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

// log("${activities[index].name}");
//         return CardWidget(
//           icon: Icon(Icons.car_crash),
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return RfidPage(
//                 id: activities[index].id ?? 0,
//                 name: activities[index].name ?? '',
//               );
//             }));
//           },
//           title: activities[index].name.toString(),
//         );
//       });
  @override
  Widget build(BuildContext context) {
    SharedPref userPref = SharedPref();

    userPref.getUsername().then((value) => setState(() {
          username = value.toString();
        }));
    return Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorManager.primary,
          actions: [
            PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (String result) {
                if (result == 'Screen 1') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailPage()));
                } else if (result == 'Screen 2') {
                  onLogout();
                }
                // Handle menu item selection
                print(result);
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white, // Change the icon color here
              ),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'Screen 1',
                  child: Text('Bluetooth Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'Screen 2',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
          title: const Text(
            "INDOARSIP",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(33),
                      topRight: Radius.circular(33))),
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, right: 4.0, top: 56),
                  child: Wrap(
                      runSpacing: 8.0,
                      spacing: 8.0,
                      children: activitesData.map((data) {
                        return CardWidget(
                            onTap: () {
                              if (data.id == 6) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RackPage(
                                      id: int.parse(data.id.toString()),
                                      name: data.name.toString());
                                }));
                              } else if (data.id == 7) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SearchPage(
                                      id: int.parse(data.id.toString()),
                                      name: data.name.toString());
                                }));
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RfidPage(
                                      id: int.parse(data.id.toString()),
                                      name: data.name.toString());
                                }));
                              }
                            },
                            title: data.name,
                            icon: data.icon);
                      }).toList()),
                ),

                // BlocBuilder<ActivitiesBloc, ActivitiesState>(
                //     bloc: ActivitiesBloc()..add(ActivitiesFetchEvent()),
                //     builder: (context, state) {
                //       switch (state.runtimeType) {
                //         case ActivitiesLoading:
                //           return const Center(
                //             child: CustomLoadingButton(),
                //           );
                //         case ActivitiesSuccess:
                //           var activities = (state as ActivitiesSuccess).activities;
                //           log("$activities");
                //           return _fetchActivities(activities);
                //         case ActivitiesFailure:
                //           var errorMessage = (state as ActivitiesFailure).errorMessage;

                //           return Text('${errorMessage.toString()}');
                //         default:
                //           return Container();
                //       }
                //     })
              ]),
            ),
          ),
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ]),
                child: SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.person)),
                        Center(child: Text('Hi, $username')),
                      ],
                    )),
              ),
            ),
          ),
        ]));
  }
}

class ActivitiesData {
  int id;
  String name;
  Widget icon;

  ActivitiesData({required this.id, required this.name, required this.icon});
}

class IconData {
  Widget icon;

  IconData({required this.icon});
}
