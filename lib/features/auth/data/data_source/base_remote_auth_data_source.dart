import '../models/user_model.dart';

abstract class BaseRemoteAuthDataSource {
  Future<UserModel> login({
    required String userName,
    required String password,
    required String role,
  });

  Future<UserModel> register({
    required String companyName,
    required String userName,
    required String password,
    required String role,
  });

  Future<String?> sendCode({
    required String phone,
  });

  Future<void> reSendCode({
    required String phone,
  });

  Future<bool> checkUsername({
    required String username,
  });
}
