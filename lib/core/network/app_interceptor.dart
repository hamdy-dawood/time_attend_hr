import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../caching/shared_prefs.dart';
import '../helper/extension.dart';
import '../routing/routes.dart';
import 'end_points.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors({
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.baseUrl = ApiConstants.cachedUrl();
    String? authToken = Caching.get(key: "access_token");
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      String? accessToken = Caching.get(key: "access_token");
      String? refreshToken = Caching.get(key: "refresh_token");
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await dio.get(
          ApiConstants.refreshTokenUrl,
          queryParameters: {
            "token": refreshToken,
          },
        ).then(
          (value) {
            String accessToken = value.data["access_token"];
            Caching.put(key: "access_token", value: accessToken);
          },
        ).catchError((error) {
          Caching.clearAllData();
          navigatorKey.currentContext!.pushNamedAndRemoveUntil(
            Routes.login,
            predicate: (Route<dynamic> route) => false,
          );
        });
        accessToken = Caching.get(key: "access_token");
        err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
        return handler.resolve(await dio.fetch(err.requestOptions));
      }
    }
    super.onError(err, handler);
  }
}
