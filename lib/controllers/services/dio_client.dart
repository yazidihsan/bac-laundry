import 'package:bt_handheld/controllers/interceptors/auth_interceptors.dart';
import 'package:bt_handheld/controllers/theme_manager/value_manager.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient() {
    addInterceptor(LogInterceptor());
  }

  final Dio dio = Dio(
    BaseOptions(baseUrl: ValueManager.baseUrlLokal),
  );

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(AuthInterceptor(dio: dio));
    dio.interceptors.add(interceptor);
  }
}
