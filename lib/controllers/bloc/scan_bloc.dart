import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bt_handheld/models/scan.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    on<ScanFetchEvent>(onScanFetchEvent);
  }
  var params = {
    "rfid": "itemx",
    "options": jsonEncode([1, 2, 3]),
  };
  FutureOr<void> onScanFetchEvent(
      ScanFetchEvent event, Emitter<ScanState> emit) async {
    emit(ScanLoading());
    try {
      var client = DioClient();
      await client.dio
          .post(
        'api/v1/scan',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(params),
      )
          .then((value) {
        List<Scan> scan = (value.data["data"] as List<dynamic>)
            .map((x) => Scan.fromJson(x))
            .toList();
        emit(ScanSuccess(scan: scan));
      }).catchError((error) {
        emit(ScanFailure(errorMessage: error.toString()));
      });
    } catch (e) {
      emit(ScanFailure(errorMessage: e.toString()));
    }
  }
}
