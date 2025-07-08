import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/add_users_employee_request_body.dart';
import '../../domain/repositories/base_users_repository.dart';
import '../data_source/base_remote_users_data_source.dart';
import '../models/users_employees_model.dart';

class UsersEmployeesRepository extends BaseUsersEmployeesRepository {
  final BaseRemoteUsersEmployeesDataSource dataSource;

  UsersEmployeesRepository(this.dataSource);

  final logger = Logger();

  @override
  Future<Either<ServerError, int>> count() async {
    try {
      final result = await dataSource.count();
      return Right(result);
    } on ServerError catch (fail) {
      logger.e(fail.message);
      return Left(fail);
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, List<UsersEmployeesModel>>> getUsersEmployees({
    required int skip,
    required String searchText,
  }) async {
    try {
      final result = await dataSource.getUsersEmployees(
        skip: skip,
        searchText: searchText,
      );
      return Right(result);
    } on ServerError catch (fail) {
      logger.e(fail.message);
      return Left(fail);
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, void>> addUsersEmployees({
    required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody,
  }) async {
    try {
      final result = await dataSource.addUsersEmployees(
        addUsersEmployeeRequestBody: addUsersEmployeeRequestBody,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } on ServerError catch (fail) {
      logger.e(fail);
      return Left(fail);
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, void>> editUsersEmployees({
    required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody,
  }) async {
    try {
      final result = await dataSource.editUsersEmployees(
        addUsersEmployeeRequestBody: addUsersEmployeeRequestBody,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } on ServerError catch (fail) {
      logger.e(fail);
      return Left(fail);
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, void>> deleteUsersEmployees({required String id}) async {
    try {
      final result = await dataSource.deleteUsersEmployees(
        id: id,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } on ServerError catch (fail) {
      logger.e(fail);
      return Left(fail);
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }
}
