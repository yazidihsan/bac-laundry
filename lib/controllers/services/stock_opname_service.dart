import 'dart:convert';
import 'dart:developer';

import 'package:bt_handheld/controllers/theme_manager/value_manager.dart';
import 'package:bt_handheld/models/box_model.dart';
import 'package:bt_handheld/models/rack_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class StockOpnameService {
  StockOpnameService() {
    addInterceptor(LogInterceptor());
  }

  final Dio dio = Dio(
    BaseOptions(baseUrl: ValueManager.baseUrl),
  );

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  Future<Either<String, List<RackModel>>> getAllRack() async {
    try {
      // final response = await dio.get('clone/location-opname');
      final response = await dio.get('/Opname/getLokasi');
      final data = response.data['data'];
      final listRack =
          List.from(data).map((e) => RackModel.fromJson(e)).toList();

      log(listRack.toString());

      return Right(listRack);
    } on DioException catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, List<BoxModel>>> locationBoxes(
      Map<String, dynamic> bodyReq) async {
    try {
      FormData formData = FormData.fromMap(bodyReq);
      // final response =
      //     await dio.post('clone/box-number-location', data: formData);
      final response =
          await dio.post('/Opname/getNomkotByLokasi', data: formData);

      final data = response.data['data'];
      final listBox = List.from(data).map((e) => BoxModel.fromJson(e)).toList();

      log(response.data.toString());
      return Right(listBox);
    } on DioException catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, String>> stockOpnameResult(
      Map<String, dynamic> stock) async {
    try {
      // final response =
      //     await dio.post('clone/stock-opname-result', data: jsonEncode(stock));
      final response =
          await dio.post('/Opname/postStokopname', data: jsonEncode(stock));

      final data = response.data['data'];

      // final stockData = StockResultModel.fromJson(data);

      log(data.toString());

      return Right(data);
    } on DioException catch (error) {
      return Left('$error');
    }
  }
}
