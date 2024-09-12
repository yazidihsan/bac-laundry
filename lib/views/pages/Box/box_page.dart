import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bt_handheld/controllers/cubit/box_cubit.dart';
import 'package:bt_handheld/controllers/cubit/stock_cubit.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:bt_handheld/controllers/services/stock_opname_service.dart';
import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/controllers/theme_manager/space_manager.dart';
import 'package:bt_handheld/controllers/util/constants.dart';
import 'package:bt_handheld/models/box_model.dart';
import 'package:bt_handheld/models/stock_result_model.dart';
import 'package:bt_handheld/views/common_widgets/custom_button.dart';
import 'package:bt_handheld/views/common_widgets/custom_card_list.dart';
import 'package:bt_handheld/views/common_widgets/custom_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxPage extends StatefulWidget {
  const BoxPage({super.key, required this.lokasi});
  final String lokasi;

  @override
  State<BoxPage> createState() => _BoxPageState();
}

class _BoxPageState extends State<BoxPage> {
  // String epcNumber = '';
  final scaffoldState = GlobalKey<ScaffoldState>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late BoxCubit boxCubit;
  late StockCubit stockCubit;
  StreamSubscription? keySubscription;
  bool scanning = false;
  int updateCount = 0;

  String lokasi = '';
  String lokasiRak = '';
  String nomorKotak = '';
  String epc = '';
  String status = 'NOT FOUND';

  List<String> epcNumbersDatas = [];
  List<Map<String, dynamic>> stocks = [];

  List<BoxModel> boxesModel = [];
  List<String> epcMatched = [];

  late Map<String, dynamic> reqBody;
  late Map<String, dynamic> bodyReq;

  bool isUpdated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gunChannel.receiveBroadcastStream().listen((event) {
      if (event == 1) {
        _scanRfid();
        log('test');
        log('scanning: $scanning');
      }

      log(event.toString());
    });
    boxCubit = BoxCubit(StockOpnameService());
    bodyReq = {'LOKASI': widget.lokasi};

    boxCubit.locationBoxes(bodyReq);
    // boxCubit.addRfid(epcNumber);
    stockCubit = StockCubit(StockOpnameService());
  }

  @override
  void didUpdateWidget(covariant BoxPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // updateEpcNumberIfNeeded();
    _scanRfid();
  }

  _scanRfid() {
    if (scanning) {
      keySubscription?.cancel();

      log('Stop scan rfid');
    } else {
      keySubscription = scanChannel.receiveBroadcastStream().listen((event) {
        // rfidBloc.add(AddRfid(rfid: event));
        setState(() {
          epcNumbersDatas.add(event);
          epcNumbersDatas = epcNumbersDatas.toSet().toList();
        });
        log(event);
      });
      log('Start Scan rfid');
    }
    setState(() {
      scanning = !scanning;
    });
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/beep.wav'));
  }

  void _stopSound() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    boxCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('epc number : ${epcNumbersDatas.toString()}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: const Text(
          "Ceklist Box",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: scanning ? ColorManager.secondary : ColorManager.primary,
              ),
            ),
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => boxCubit,
          ),
          BlocProvider(
            create: (context) => stockCubit,
          ),
        ],
        child: BlocBuilder<BoxCubit, BoxState>(
          builder: (context, state) {
            if (state is BoxLoading) {
              return const Center(
                child: CustomLoadingButton(),
              );
            }
            if (state is BoxSuccess) {
              boxesModel = state.listBox;

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (context, index) {
                        lokasi = boxesModel[index].lokasi.toString();
                        lokasiRak = boxesModel[index].lokasiRak.toString();
                        nomorKotak = boxesModel[index].nomkot.toString();
                        epc = boxesModel[index].epc.toString();
                        boxesModel[index].status = status;

                        if (epcNumbersDatas.contains(epc) &&
                            !epcMatched.contains(epc)) {
                          boxesModel[index].status = 'FOUND';

                          epcMatched.add(epc);
                          epcMatched = epcMatched.toSet().toList();

                          _playSound();
                          log('found :${epc.toString()}');
                        } else {
                          boxesModel[index].status = 'NOT FOUND';
                          // _stopSound();
                          log('not found :${epc.toString()}');
                        }

                        StockResultModel stockResultModel =
                            StockResultModel(boxes: boxesModel);

                        reqBody = stockResultModel.toJson();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                          ),
                          child: CustomCardList(
                            isDetailList: true,
                            lokasi: lokasi,
                            lokasiRak: lokasiRak,
                            nomorKotak: nomorKotak,
                            epc: epc,
                            statusColor: !epcNumbersDatas.contains(epc)
                                ? Colors.red
                                : Colors.green,
                            statusIcon: !epcNumbersDatas.contains(epc)
                                ? Icons.close
                                : Icons.check,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 8.0.spaceY,
                      itemCount: boxesModel.length,
                    ),
                  ),
                  BlocListener<StockCubit, StockState>(
                    listener: (context, state) {
                      // TODO: implement listener
                      if (state is StockFailed) {
                        String message = state.message;
                        if (message.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: ColorManager.primary,
                              content: Text(message)));
                        }
                      }
                      if (state is StockSuccess) {
                        String message = state.message;
                        if (message.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: ColorManager.secondary,
                              content: Text(message)));
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: BlocBuilder<StockCubit, StockState>(
                      builder: (context, state) {
                        if (state is StockLoading) {
                          return const Center(child: CustomLoadingButton());
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            children: [
                              Text(
                                  'Total Scan : ${epcMatched.length}/${boxesModel.length}'), // boxesModel.length
                              8.0.spaceY,
                              CustomButton(
                                  onPressed: () {
                                    log('hasil submit: ${reqBody.toString()}');
                                    stockCubit.stockResult(reqBody);
                                  },
                                  title: "Submit"),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class RfidData {
  final String epc;

  RfidData({required this.epc});
}
