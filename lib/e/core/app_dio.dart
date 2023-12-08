import 'package:dio/dio.dart';
import 'package:login_screen/e/core/app_endpoints.dart';
import 'package:login_screen/e/ui/shared.dart';

class AppDio {
  static late Dio _dio;

  static void init() {
    BaseOptions baseOptions = BaseOptions(baseUrl: EndPoints.baseUrl);
    _dio = Dio(baseOptions);
  }

  static Future<Response<dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(headers: {
        'lang': PreferenceUtils.getString(PrefKeys.language),
        'Authorization': PreferenceUtils.getString(PrefKeys.apiToken),
        'Content-Type': 'application/json',
      }),
    );
  }

  static Future<Response<dynamic>> post({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) {
    return _dio.post(
      endpoint,
      queryParameters: queryParameters,
      data: body,
      options: Options(headers: {
        'lang': PreferenceUtils.getString(PrefKeys.language),
        'Authorization': PreferenceUtils.getString(PrefKeys.apiToken),
        'Content-Type': 'application/json',
      }),
    );
  }

  static Future<Response<dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) {
    return _dio.put(
      endpoint,
      queryParameters: queryParameters,
      data: body,
      options: Options(headers: {
        'lang': PreferenceUtils.getString(PrefKeys.language),
        'Authorization': PreferenceUtils.getString(PrefKeys.apiToken),
        'Content-Type': 'application/json',
      }),
    );
  }

  static Future<Response<dynamic>> delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) {
    return _dio.delete(
      endpoint,
      queryParameters: queryParameters,
      data: body,
      options: Options(headers: {
        'lang': PreferenceUtils.getString(PrefKeys.language),
        'Authorization': PreferenceUtils.getString(PrefKeys.apiToken),
        'Content-Type': 'application/json',
      }),
    );
  }
}
