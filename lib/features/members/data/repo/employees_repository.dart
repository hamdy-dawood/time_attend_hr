import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../../domain/entities/add_employees_request_body.dart';
import '../../domain/entities/employees_entity.dart';
import '../../domain/entities/subjects_entity.dart';
import '../../domain/repositories/base_employees_repository.dart';
import '../data_source/base_remote_employees_data_source.dart';

class EmployeesRepository extends BaseEmployeesRepository {
  final BaseRemoteEmployeesDataSource dataSource;

  EmployeesRepository(this.dataSource);

  final logger = Logger();

  @override
  Future<Either<ServerError, List<EmployeesEntity>>> getEmployees({
    required String searchText,
  }) async {
    try {
      final result = await dataSource.getEmployees(
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
  Future<Either<ServerError, EmployeesEntity>> addEmployees({
    required AddEmployeesRequestBody addMembersRequestBody,
  }) async {
    try {
      final result = await dataSource.addEmployees(
        addMembersRequestBody: addMembersRequestBody,
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
  Future<Either<ServerError, EmployeesEntity>> editEmployees({
    required AddEmployeesRequestBody addMembersRequestBody,
  }) async {
    try {
      final result = await dataSource.editEmployees(
        addMembersRequestBody: addMembersRequestBody,
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
  Future<Either<ServerError, void>> deleteEmployees({required String id}) async {
    try {
      final result = await dataSource.deleteEmployees(
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

  @override
  Future<Either<ServerError, List<SubjectsEntity>>> getSubjects({
    required String enrollId,
  }) async {
    try {
      final result = await dataSource.getSubjects(
        enrollId: enrollId,
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
}
