import 'package:dio/dio.dart';
import 'package:time_attend_recognition/core/network/dio.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';

import '../models/user_model.dart';
import 'base_remote_auth_data_source.dart';

class RemoteAuthDataSource extends BaseRemoteAuthDataSource {
  final dioManager = DioManager();

  @override
  Future<UserModel> login({
    required String userName,
    required String password,
    required String role,
  }) async {
    final Response response = await dioManager.post(
      ApiConstants.login ,
      data: {
        "user_name": userName,
        "pass": password,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> register({
    required String companyName,
    required String userName,
    required String password,
    required String role,
  }) async {
    final Response response = await dioManager.post(
      ApiConstants.registerAdmin,
      data: {
        "username": userName,
        "password": password,
        "displayName": companyName,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<String?> sendCode({
    required String phone,
  }) async {
    final Response response = await dioManager.post(
      ApiConstants.send,
      data: {
        "phone": phone,
      },
    );

    return response.data["verificationId"];
  }

  @override
  Future<void> reSendCode({
    required String phone,
  }) async {
    await dioManager.post(
      ApiConstants.resend,
      data: {
        "phone": phone,
      },
    );
  }

  @override
  Future<bool> checkUsername({
    required String username,
  }) async {
    final Response response = await dioManager.get(
      ApiConstants.checkUsername,
      queryParameters: {
        "username": username,
      },
    );

    return response.data["usernameAvailable"] ?? false;
  }
}
