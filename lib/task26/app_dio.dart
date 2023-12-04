import 'package:dio/dio.dart';
import 'package:login_screen/task26/shared.dart';

class AppDio {
  static late Dio _dio;

  static Future<void> init() async {
    BaseOptions baseOptions = BaseOptions(
        baseUrl: "https://newsapi.org/v2/top-headlines");
    _dio = Dio(baseOptions);
  }


  static Future<Response<dynamic>> get({
    required String category,
    required String currentCountry,
  }) {
    return _dio.get(
      "",
      queryParameters: {
        "country": currentCountry,
        "category": category,
        "apiKey": "b0bf7c0e382f4a27b7df219617565a0f",
      },
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