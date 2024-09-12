import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bt_handheld/controllers/bloc/rfid_bloc.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/controllers/theme_manager/space_manager.dart';
import 'package:bt_handheld/controllers/theme_manager/value_manager.dart';
import 'package:bt_handheld/models/rfid_model.dart';
import 'package:bt_handheld/models/scan.dart';
import 'package:bt_handheld/controllers/util/constants.dart';
import 'package:bt_handheld/views/common_widgets/custom_button.dart';
import 'package:bt_handheld/views/common_widgets/custom_card_list.dart';
import 'package:bt_handheld/views/pages/Home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RfidPage extends StatefulWidget {
  final int id;
  final String name;
  const RfidPage({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<RfidPage> createState() => _RfidPageState();
}

class _RfidPageState extends State<RfidPage> {
  final rfidBloc = RfidBloc();

  bool scanning = false;
  StreamSubscription? keySubscription;
  String message = '';

  // String activityName = "";
  // String rfidData = "";
  // // DateTime timeStamp = DateTime.now();
  // String timeStamp = "";
  String rfidData = "";
  String nomorKotak = "";
  String kodePelanggan = "";
  String nomorSuratJalan = "";
  String status = "";

  List<Scan> scan = [];
  String? selectedKotak;
  String? selectedKontainer;
  // RfidModel? rfid;
  List<RfidModel> rfids = [];

  List<String> rfidEvents = [];

  bool isLoading = false;
  bool isGetRfid = false;

  TextEditingController controller = TextEditingController();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // final params = {
  //   "rfid": "",
  //   "activity": widget.name.toString(),

  // };

  @override
  void initState() {
    isLoading = true;
    log("id : ${widget.id}");
    log("name : ${widget.name}");
    gunChannel.receiveBroadcastStream().listen((event) {
      if (event == 1) {
        _scanRfid();
        log('test');
        log('scanning: $scanning');
      }

      log(event.toString());
    });

    super.initState();
  }

  _scanRfid() {
    if (scanning) {
      keySubscription?.cancel();

      log('Stop scan rfid');
    } else {
      keySubscription = scanChannel.receiveBroadcastStream().listen((event) {
        // rfidBloc.add(AddRfid(rfid: event));

        onScanFetchEvent(event);
        log(event);
      });
      log('Start Scan rfid');
    }
    setState(() {
      scanning = !scanning;
    });
  }

  void _playSound() async {
    await _audioPlayer
        .play(AssetSource('sounds/beep.wav')); // Add your sound file to assets
  }

  @override
  void dispose() {
    rfidBloc.close();
    keySubscription?.cancel();
    super.dispose();
  }

  Future<void> onScanFetchEvent(dynamic event) async {
    try {
      var client = DioClient();
      await client.dio
          .post(
        'scan',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({'epc': event, 'activity_id': widget.id}),
      )
          .then((value) {
        if (value.data["data"] != null) {
          setState(() {
            isLoading = false;
          });
          onGetRFID("$event");
        } else {
          setState(() {
            isLoading = false;
          });
          // // ignore: use_build_context_synchronously
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     backgroundColor: ColorManager.primary,
          //     content: Text(value.data['message'].toString())));
          // ValueManager.customToast(value.data['message'].toString());
        }

        log('data validasi :${value.data["data"].toString()}');
      }).catchError((error) {
        log(error.toString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
        // emit(ScanFailure(errorMessage: error.toString()));
      });
    } catch (e) {
      log(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // ValueManager.customToast(e.toString());
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  Future<void> onGetRFID(String event) async {
    // Future<void> onScanFetchEvent(String rfid) async {
    // emit(ScanLoading());
    var dio = Dio();
    // var client = DioClient();
    FormData formData = FormData.fromMap({'EPC': event});

    setState(() {
      isLoading = true;
      isGetRfid = true;
    });

    try {
      // 'api/v1/clone/get-rfid',
      await dio
          .post(
        '${ValueManager.baseUrl}/Rfid/getRFID',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data:
            // jsonEncode({'EPC': event}),
            formData,
      )
          .then((value) {
        log("data indoarsip : ${value.data["data"].toString()}");
        // setState(() {
        //   rfids.add(RfidModel.fromJson(value.data["data"][0]));
        //   isLoading = false;
        // });
        if (value.data["data"] != null) {
          setState(() {
            rfids.add(RfidModel.fromJson(value.data["data"][0]));
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
        // emit(ScanFailure(errorMessage: error.toString()));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  Future<void> onReceived() async {
    var dio = Dio();

    setState(() {
      isLoading = true;
    });

    final dataEpc = rfids.map((data) => data.epc).toSet().toList();
    final dataNomKot = rfids.map((data) => data.nomorKotak).toSet().toList();
    final dataKodPlg = rfids.map((data) => data.kodePelanggan).toList();
    final dataNoSlj = rfids.map((data) => data.nomorSuratJalan).toList();
    final dataKodeKotak = selectedKotak.toString();
    try {
      await dio
          .post(
        '${ValueManager.baseUrl}/Rfid/postReceived',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({
          "EPC": dataEpc,
          "NOMKOT": dataNomKot,
          "KODKOT": [dataKodeKotak],
          "KODPLG": dataKodPlg,
          "NO_SJTT": dataNoSlj,
        }),
      )
          .then((value) {
        if (value.data['data'][0] != null) {
          setState(() {
            isLoading = false;
          });
          if (value.data['message'] == 'Success') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.secondary,
                content: Text(value.data['data'][0]['message'].toString())));
            Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.primary,
                content: Text(value.data['data'][0]['message'].toString())));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorManager.primary,
              content: Text(value.data['data'][0]['message'].toString())));
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fumigasiIn() async {
    var dio = Dio();

    setState(() {
      isLoading = true;
    });

    try {
      final dataEpc = rfids.map((data) => data.epc).toSet().toList();
      final dataNomKot = rfids.map((data) => data.nomorKotak).toSet().toList();
      final dataKontainer = selectedKontainer.toString();

      log('dataEpc : ${dataEpc.toString()}');
      log('data NomKot : ${dataNomKot.toString()}');
      log('data kontainer : ${dataKontainer.toString()}');
      // jsonEncode(dataEpc);
      await dio
          .post(
        '${ValueManager.baseUrl}/Rfid/postFumigasi',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(
            {'EPC': dataEpc, 'NOMKOT': dataNomKot, 'KONTAINER': dataKontainer}),
      )
          .then((value) {
        log('data fumigasi In : ${value.data['data'][0].toString()}');
        if (value.data['data'][0] != null) {
          setState(() {
            isLoading = false;
          });
          if (value.data['message'] == 'Success') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.secondary,
                content: Text(value.data['data'][0]['message'].toString())));
            Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.primary,
                content: Text(value.data['data'][0]['message'].toString())));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorManager.primary,
              content: Text(value.data['data'][0]['message'].toString())));
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fumigasiOut() async {
    var dio = Dio();

    setState(() {
      isLoading = true;
    });

    try {
      // int rfidIndex = 0;
      // rfids.map((data) {
      //   rfidIndex = rfids.indexOf(data);
      // }).toList();

      final dataEpc = rfids.map((data) => data.epc).toSet().toList();
      final dataNomKot = rfids.map((data) => data.nomorKotak).toSet().toList();
      await dio
          .post(
        '${ValueManager.baseUrl}/Rfid/postFumigasiOut',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({
          "EPC": dataEpc,
          "NOMKOT": dataNomKot,
        }),
      )
          .then((value) {
        if (value.data['data'][0] != null) {
          setState(() {
            isLoading = false;
          });
          if (value.data['message'] == 'Success') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.secondary,
                content: Text(value.data['data'][0]['message'].toString())));
            Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.primary,
                content: Text(value.data['data'][0]['message'].toString())));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorManager.primary,
              content: Text(value.data['data'][0]['message'].toString())));
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  Future<void> onStorage() async {
    var dio = Dio();

    setState(() {
      isLoading = true;
    });

    try {
      final dataEpc = rfids.map((data) => data.epc).toSet().toList();
      final dataNomKot = rfids.map((data) => data.nomorKotak).toSet().toList();
      await dio
          .post(
        '${ValueManager.baseUrl}/Rfid/postStorage',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({
          "EPC": dataEpc,
          "NOMKOT": dataNomKot,
        }),
      )
          .then((value) {
        if (value.data['data'][0] != null) {
          setState(() {
            isLoading = false;
          });
          if (value.data['message'] == 'Success') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.secondary,
                content: Text(value.data['data'][0]['message'].toString())));
            Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.primary,
                content: Text(value.data['data'][0]['message'].toString())));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorManager.primary,
              content: Text(value.data['data'][0]['message'].toString())));
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  Future<void> onDelivery() async {
    var dio = Dio();

    setState(() {
      isLoading = true;
    });

    try {
      // int rfidIndex = 0;
      // rfids.map((data) {
      //   rfidIndex = rfids.indexOf(data);
      // }).toList();
      final dataEpc = rfids.map((data) => data.epc).toSet().toList();
      final dataNomKot = rfids.map((data) => data.nomorKotak).toSet().toList();

      log('dataEpc : ${dataEpc.toString()}');
      log('data NomKot : ${dataNomKot.toString()}');
      await dio
          .post(
        '${ValueManager.baseUrl}/Rfid/postDelivery',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({
          "EPC": dataEpc,
          "NOMKOT": dataNomKot,
        }),
      )
          .then((value) {
        if (value.data['data'][0] != null) {
          setState(() {
            isLoading = false;
          });

          if (value.data['message'] == 'Success') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.secondary,
                content: Text(value.data['data'][0]['message'].toString())));
            Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: ColorManager.primary,
                content: Text(value.data['data'][0]['message'].toString())));
          }
          // ignore: use_build_context_synchronously
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorManager.primary,
              content: Text(value.data['data'][0]['message'].toString())));
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorManager.primary,
            content: Text(error.toString())));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorManager.primary, content: Text(e.toString())));
      // emit(ScanFailure(errorMessage: e.toString()));
    }
  }

  List<String> nomorKontainer = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  List<String> kodeKotak = [
    "A0",
    "B144",
    "B216",
    "B288",
    "D162",
    "D288",
    "G144",
    "H016",
    "J048",
    "J060",
    "J120",
    "J204",
    "J216",
    "J288",
    "J324",
    "K018",
    "K036",
    "K042",
    "K048",
    "K049",
    "K054",
    "K056",
    "K060",
    "K066",
    "K069",
    "K072",
    "K084",
    "K090",
    "K096",
    "K108",
    "K114",
    "K120",
    "K126",
    "K128",
    "K132",
    "K144",
    "K162",
    "K168",
    "K180",
    "K198",
    "K204",
    "K216",
    "K234",
    "K252",
    "K270",
    "K285",
    "K288",
    "K306",
    "K312",
    "K324",
    "K330",
    "K360",
    "K396",
    "K405",
    "K408",
    "K480",
    "K486",
    "K504",
    "K540",
    "K660",
    "K72",
    "K84",
    "KBCA",
    "L108",
    "P144",
    "P288",
    "Q144",
    "T009",
    "T032",
    "T050",
    "T060",
    "W060",
    "W120",
    "W216",
  ];

  List<ActivitiesData> activitesData = [
    ActivitiesData(id: 0, name: "transit", icon: icons[0]),
    ActivitiesData(id: 1, name: "RECEIVED", icon: icons[1]),
    ActivitiesData(id: 2, name: "FUMIGASI-IN", icon: icons[2]),
    ActivitiesData(id: 3, name: "FUMIGASI-OUT", icon: icons[3]),
    ActivitiesData(id: 4, name: "STORAGE", icon: icons[4]),
    // ActivitiesData(id: 5, name: "DELIVERY", icon: icons[5]),
    // ActivitiesData(id: 5, name: "OUT", icon: icons[4])
  ];
  String? findNameById(List<ActivitiesData> items, int id) {
    ActivitiesData? foundItem = items.firstWhere(
      (item) => item.id == id - 1,
    );

    return foundItem.name;
  }

  @override
  Widget build(BuildContext context) {
    List<RfidModel> rfidDatas = rfids.toSet().toList();

    String status = '';
    int searchId = widget.id;
    String? name = findNameById(activitesData, searchId);

    final statusButton =
        rfidDatas.where((data) => data.status != name.toString());
    if (name != null) {
      log('Found name: $name');
    } else {
      log('No item found with id $searchId');
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.name.toString(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color:
                      scanning ? ColorManager.secondary : ColorManager.primary,
                  // borderRadius: BorderRadius.circular(10.0),
                ),
                // child: Center(
                //   child: Text(
                //     'Hello, Flutter!',
                //     style: TextStyle(color: Colors.white, fontSize: 18),
                //   ),
                // ),
              ),
            ),
          ],
          // automaticallyImplyLeading: false,
        ),
        body:

            // isLoading
            //     ? Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Image.asset(
            //             'assets/no_rfid.png',
            //             width: 350,
            //             height: 400,
            //           ),
            //           Text(
            //             "Mohon Scan Rfid",
            //             style: TextStyle(
            //                 color: Colors.black45,
            //                 fontSize: 24,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //           200.0.spaceY,
            //           Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 10),
            //               child: CustomButton(onPressed: null, title: 'Submit'))
            //         ],
            //       )
            //     :

            // isLoading == true
            //     ? const Center(
            //         child: CustomLoadingButton(),
            //       )
            //     :
            Column(children: [
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                status = rfidDatas[index].status.toString();

                return VisibilityDetector(
                  key: Key('item-$index'),
                  onVisibilityChanged: (visibilityInfo) {
                    if (visibilityInfo.visibleFraction > 0.5) {
                      _playSound();
                    }
                  },
                  child:
                      // CustomCardList(
                      //   highlightColor: status != name
                      //       ? Colors.red.withOpacity(0.2)
                      //       : Colors.transparent,
                      //   nomorKotak: rfidDatas[index].nomorKotak.toString(),
                      //   status: rfidDatas[index].status.toString(),
                      //   kodePelanggan: rfidDatas[index].kodePelanggan.toString(),
                      //   noSuratJalan: rfidDatas[index].nomorSuratJalan.toString(),
                      // )
                      Container(
                    decoration: BoxDecoration(
                      color: status != name
                          ? Colors.red.withOpacity(0.2)
                          : Colors.transparent, // Highlight even items
                      border: const Border(
                          bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.5)), // Example of additional decoration
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "nomor kotak",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                rfidDatas[index].nomorKotak.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              16.0.spaceY,
                              const Text(
                                "status",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                rfidDatas[index].status.toString(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "kode pelanggan",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                rfidDatas[index].kodePelanggan.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              16.0.spaceY,
                              const Text(
                                "nomor surat jalan",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                rfidDatas[index].nomorSuratJalan.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => 8.0.spaceY,
              itemCount: rfidDatas.length,
            ),
          ),
          Text("Total scan : ${rfidDatas.length}"),
          8.0.spaceY,
          // SizedBox(height: MediaQuery.of(context).size.height / 2),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 24),
            child: CustomButton(
                onPressed: statusButton.isNotEmpty || rfids.isEmpty
                    ? null
                    : () {
                        if (searchId == 1 || searchId == 2) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                switch (searchId) {
                                  case 1:
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Dialog(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Text(
                                                  'Masukkan Nomor Kotak'),
                                              16.0.spaceY,
                                              DropdownButton(
                                                value: selectedKotak,
                                                hint: const Text(
                                                    '- Pilih Nomor Kotak -'),
                                                isExpanded: true,
                                                items: kodeKotak
                                                    .map((item) =>
                                                        DropdownMenuItem(
                                                          value: item,
                                                          child: Text(item),
                                                        ))
                                                    .toList(),
                                                onChanged: (newValue) {
                                                  selectedKotak = newValue!;
                                                  setState(() {
                                                    selectedKotak = newValue;
                                                  });
                                                },
                                              ),
                                              16.0.spaceY,
                                              CustomButton(
                                                  onPressed: () {
                                                    onReceived();
                                                  },
                                                  title: "OK")
                                            ],
                                          ),
                                        ),
                                      );
                                    });

                                  case 2:
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Dialog(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Text(
                                                  'Masukkan Nomor Kontainer'),
                                              16.0.spaceY,
                                              DropdownButton(
                                                value: selectedKontainer,
                                                hint: const Text(
                                                    '- Pilih Nomor Kontainer -'),
                                                isExpanded: true,
                                                items: nomorKontainer
                                                    .map((item) =>
                                                        DropdownMenuItem(
                                                          value: item,
                                                          child: Text(item),
                                                        ))
                                                    .toList(),
                                                onChanged: (newValue) {
                                                  selectedKontainer = newValue!;
                                                  setState(() {
                                                    selectedKontainer =
                                                        newValue;
                                                  });
                                                },
                                              ),
                                              16.0.spaceY,
                                              CustomButton(
                                                  onPressed: () {
                                                    fumigasiIn();
                                                    // if (!isLoading) {
                                                    //   return;
                                                    // }

                                                    // Navigator.of(context).pop();
                                                  },
                                                  title: "OK")
                                            ],
                                          ),
                                        ),
                                      );
                                    });

                                  default:
                                    return Container();
                                }
                              });
                        } else if (searchId == 3) {
                          fumigasiOut();
                        } else if (searchId == 4) {
                          onStorage();
                        } else {
                          onDelivery();
                        }
                      },
                title: 'Submit'),
          )
        ]));
  }
}

class Rfid {
  final String activityName;
  final String rfId;
  final DateTime timeStamp;

  Rfid(
      {required this.activityName,
      required this.rfId,
      required this.timeStamp});
}

class Kotak {
  int id;
  String nomorKotak;

  Kotak({required this.id, required this.nomorKotak});
}
