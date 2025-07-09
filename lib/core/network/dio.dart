import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../caching/shared_prefs.dart';
import '../errors/server_errors.dart';
import 'app_interceptor.dart';
import 'end_points.dart';

class DioManager {
  Dio? _dioInstance;

  Dio? get dio {
    _dioInstance ??= initDio();
    return _dioInstance;
  }

  Dio initDio() {
    final Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.cachedUrl(),
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 2),
    ));

    dio.interceptors.add(AppInterceptors(dio: dio));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        request: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
        maxWidth: 120,
      ));
    }

    String token = Caching.get(key: "access_token") ?? "";

    token.isNotEmpty ? dio.options.headers["Authorization"] = "Bearer $token" : null;

    return dio;
  }

  void update() => _dioInstance = initDio();

  Future<Response> get(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio!.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: header),
      );
      return response;
    } on DioException catch (error) {
      throw ServerFailure.fromDiorError(error);
    }
  }

  Future<Response> post(
    String url, {
    Map<String, dynamic>? header,
    Map<String, dynamic>? json,
    dynamic data,
  }) {
    try {
      return dio!.post(
        url,
        data: data,
        queryParameters: json,
        options: Options(headers: header),
      );
    } on DioException catch (error) {
      throw ServerFailure.fromDiorError(error);
    }
  }

  Future<Response> put(String url, {Map<String, dynamic>? header, dynamic data}) {
    try {
      return dio!.put(
        url,
        data: data,
        options: Options(headers: header),
      );
    } on DioException catch (error) {
      throw ServerFailure.fromDiorError(error);
    }
  }

  Future<Response> delete(String url, {Map<String, dynamic>? header, dynamic data}) {
    try {
      return dio!.delete(
        url,
        data: data,
        options: Options(headers: header),
      );
    } on DioException catch (error) {
      throw ServerFailure.fromDiorError(error);
    }
  }

  void setBaseUrl(String baseUrl) {
    dio!.options.baseUrl = baseUrl;
  }
}
