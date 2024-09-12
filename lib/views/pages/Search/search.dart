import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bt_handheld/controllers/cubit/find_my_box_cubit.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:bt_handheld/controllers/services/find_my_box_service.dart';
import 'package:bt_handheld/controllers/theme_manager/color_manager.dart';
import 'package:bt_handheld/controllers/theme_manager/space_manager.dart';
import 'package:bt_handheld/controllers/util/constants.dart';
import 'package:bt_handheld/views/common_widgets/custom_button.dart';
import 'package:bt_handheld/views/common_widgets/custom_loading_button.dart';
import 'package:bt_handheld/views/common_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.id, required this.name});
  final int id;
  final String name;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  // ..setPlayerMode(PlayerMode.lowLatency);
  // final AudioCache _audioCache = AudioCache(prefix: 'assets/sounds/');

  late FindMyBoxCubit findMyBoxCubit;

  bool scanning = false;
  StreamSubscription? keySubscription;

  bool isLoading = false;

  String _desiredEpc = "";

  List<String> currentEpc = [];
  // final player = AudioPlayer();

  // void playAudio(String url) async {
  //   try {
  //     await player.play(AssetSource(url));
  //     await player.resume();
  //   } catch (e) {
  //     // Handle exceptions such as IllegalStateException
  //     print('Error: $e');
  //     // Optionally reset the player
  //     await player.release();
  //   }
  // }
  // Add a variable to store the last play time
  DateTime? _lastPlayTime;

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

    findMyBoxCubit = FindMyBoxCubit(FindMyBoxService());
    // _preloadSound();
    _audioPlayer.setSource(AssetSource('sounds/beep_faster.wav'));
  }

  // @override
  // void didUpdateWidget(covariant SearchPage oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   _scanRfid();
  // }

  void _handleNewEpc(String epc) async {
    // data dummy epc
    // String desiredEpc = 'E200011B6515010515007F58';
    if (_desiredEpc == epc) {
      // playAudio('sounds/beep-06.mp3');
      await _audioPlayer.play(AssetSource('sounds/beep_faster.wav'));
      // _audioCache.loadPath('beep_cutted.wav');
      // await _audioPlayer.resume();
      // Calculate the interval since the last play
      if (_lastPlayTime != null) {
        Duration interval = DateTime.now().difference(_lastPlayTime!);
        log('Interval between sounds: ${interval.inMilliseconds} ms');
      }

      // Update the last play time to the current time
      _lastPlayTime = DateTime.now();
      // await _audioPlayer.resume();
      log("EPC  matched: $epc");
    } else {
      log("EPC does not match: $epc");
    }
  }

  void _preloadSound() async {
    // playAudio('sounds/beep-06.mp3');
    // await Future.delayed(Duration(milliseconds: 500)); // Play for 500ms
    // Timer.periodic(Duration(milliseconds: 100), (timer) async {
    // await _audioPlayer.setSource(AssetSource('sounds/beep.mp3'));
    // await _audioPlayer.resume();
    // await _audioPlayer.play(AssetSource('sounds/beep-06.mp3'));
    // });
    // await _audioPlayer.stop();
  }

  _scanRfid() {
    if (scanning) {
      keySubscription?.cancel();

      log('Stop scan rfid');
    } else {
      // await _audioPlayer.setSource(AssetSource('sounds/beep-06.mp3'));
      keySubscription = scanChannel.receiveBroadcastStream().listen((event) {
        _handleNewEpc(event);
        // _playSound();

        // setState(() {
        //   currentEpc.add(event);
        // });
        // if (_desiredEpc == event) {
        //   _playSound();
        // }
        // if (event == _currentEpc) {
        //   _playSound();
        //   // playAudio('sounds/beep-06.mp3');
        //   log("EPC  matched: $event");
        // } else {
        //   log("EPC does not match: $event");
        // }

        log(event);
      });
      log('Start Scan rfid');
    }
    setState(() {
      scanning = !scanning;
    });
  }

  void _stopSound() async {
    await _audioPlayer.stop();
  }

  void _playSound() async {
    // playAudio('sounds/beep-06.mp3');
    // await Future.delayed(Duration(milliseconds: 500)); // Play for 500ms
    // Timer.periodic(Duration(milliseconds: 100), (timer) async {
    // await _audioPlayer.setSource(AssetSource('sounds/beep-06.mp3'));
    // await _audioPlayer.resume();
    await _audioPlayer.play(AssetSource('sounds/beep.wav'));
    // });
    // await _audioPlayer.stop();
  }

  // //Fungsi untuk mengatur intensitas suara berdasarkan RSSI

  // void _playSoundWithIntensity(int rssi) async {
  //   _soundTimer?.cancel(); // Batalkan timer sebelumnya jika ada

  //   int interval =
  //       _calculateIntervalFromRssi(rssi); //Hitung interval berdasarkan RSSI

  //   //Timer untuk memutar suara susuai interval yang dihitung
  //   _soundTimer =
  //       Timer.periodic(Duration(milliseconds: interval), (timer) async {
  //     await _audioPlayer.play(
  //         AssetSource('sounds/beep-06.mp3')); // Add your sound file to assets
  //   });
  // }

  // // Fungsi untuk mengatur interval berdasarkan RSSI
  // int _calculateIntervalFromRssi(int rssi) {
  //   int baseInterval = 1000; // interval dasar dalam milidetik
  //   int maxRssi = -30; // Nilai RSSI tertinggi (jarak terdekat)
  //   int minRssi = -90; // Nilai RSSI terendah (jarak terjauh)

  //   double scale =
  //       (rssi - minRssi) / (maxRssi - minRssi); //skala antara 0 hingga 1
  //   int interval = baseInterval -
  //       (scale * 800).toInt(); // Kurangi interval berdasarkan jarak

  //   return interval.clamp(
  //       200, baseInterval); // jaga interval dalam batas 200ms - 1000ms
  // }

  void onLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    findMyBoxCubit.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('data epcs:${currentEpc.toString()}');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.name.toString(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color:
                      scanning ? ColorManager.secondary : ColorManager.primary,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => findMyBoxCubit,
            child: BlocListener<FindMyBoxCubit, FindMyBoxState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is FindMyBoxFailed) {
                  String message = state.message;

                  if (message.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: ColorManager.primary,
                        content: Text(message)));
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    CustomTextField(
                        controller: _controller, title: 'Input Nomor Kotak'),
                    14.0.spaceY,
                    BlocBuilder<FindMyBoxCubit, FindMyBoxState>(
                      builder: (context, state) {
                        if (state is FindMyBoxLoading) {
                          return const Center(
                            child: CustomLoadingButton(),
                          );
                        }
                        return CustomButton(
                            onPressed: () {
                              findMyBoxCubit.myDesiredEpc(_controller.text);
                            },
                            title: 'Cari');
                      },
                    ),
                    BlocBuilder<FindMyBoxCubit, FindMyBoxState>(
                      builder: (context, state) {
                        if (state is FindMyBoxSuccess) {
                          final data = state.foundEpc;
                          _desiredEpc = data[0].epc.toString();

                          log(data.toString());
                          return Column(
                            children: [
                              40.0.spaceY,
                              Center(
                                child: Text(
                                    'Rfid yang mau anda cari :  $_desiredEpc, silahkan start scan...'),
                              ),
                              180.0.spaceY,
                              scanning == true
                                  ? Column(
                                      children: [
                                        LoadingAnimationWidget
                                            .threeArchedCircle(
                                                color: ColorManager.primary,
                                                size: 50),
                                        10.0.spaceY,
                                        const Text('Sedang mencari...')
                                      ],
                                    )
                                  : Container(),
                            ],
                          );
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
