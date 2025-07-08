import 'package:dartz/dartz.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../entities/login_entity.dart';

abstract class BaseAuthRepository {
  Future<Either<ServerError, UserEntity>> login({
    required String userName,
    required String password,
    required String role,
  });

  Future<Either<ServerError, UserEntity>> register({
    required String companyName,
    required String userName,
    required String password,
    required String role,
  });

  Future<Either<ServerError, String?>> sendCode({
    required String phone,
  });

  Future<Either<ServerError, void>> reSendCode({
    required String phone,
  });

  Future<Either<ServerError, bool>> checkUsername({
    required String username,
  });
}
