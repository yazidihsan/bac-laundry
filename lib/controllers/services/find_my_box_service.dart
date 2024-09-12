import 'dart:developer';

import 'package:bt_handheld/controllers/theme_manager/value_manager.dart';
import 'package:bt_handheld/models/find_box_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class FindMyBoxService {
  FindMyBoxService() {
    addInterceptor(LogInterceptor());
  }

  final Dio dio = Dio(
    BaseOptions(baseUrl: ValueManager.baseUrl),
  );

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  Future<Either<String, List<FindBoxModel>>> desiredEpc(String nomkot) async {
    try {
      FormData formData = FormData.fromMap({'nomkot': nomkot});

      final response = await dio.post('/Rfid/getEpcByNomkot', data: formData);
      // final response = await dio.post('clone/epc-by-nomkot', data: formData);
      final data = response.data['data'];

      final desiredEpc =
          List.from(data).map((e) => FindBoxModel.fromJson(e)).toList();

      log(data.toString());

      return Right(desiredEpc);
    } on DioException catch (error) {
      return Left('$error');
    }
  }
}
