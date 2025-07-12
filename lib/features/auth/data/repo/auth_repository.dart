import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../../domain/entities/login_entity.dart';
import '../../domain/repository/base_auth_repository.dart';
import '../data_source/base_remote_auth_data_source.dart';

class AuthRepository extends BaseAuthRepository {
  final BaseRemoteAuthDataSource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<Either<ServerError, UserEntity>> login({
    required String userName,
    required String password,
    required String role,
  }) async {
    try {
      final result = await dataSource.login(
        userName: userName,
        password: password,
        role: role,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } /*catch (error) {
      return Left(
        ServerFailure(error.toString()),
      );
    }*/
  }

  @override
  Future<Either<ServerError, UserEntity>> register({
    required String companyName,
    required String userName,
    required String password,
    required String role,
  }) async {
    try {
      final result = await dataSource.register(
        companyName: companyName,
        userName: userName,
        password: password,
        role: role,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } catch (error) {
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, String?>> sendCode({
    required String phone,
  }) async {
    try {
      final result = await dataSource.sendCode(
        phone: phone,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } catch (error) {
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, void>> reSendCode({
    required String phone,
  }) async {
    try {
      final result = await dataSource.reSendCode(
        phone: phone,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } catch (error) {
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, bool>> checkUsername({
    required String username,
  }) async {
    try {
      final result = await dataSource.checkUsername(
        username: username,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } catch (error) {
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }
}
