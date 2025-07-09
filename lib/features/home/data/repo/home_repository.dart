import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../../domain/entities/home_count_entity.dart';
import '../../domain/entities/members_attendance_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/report_count_entity.dart';
import '../../domain/repositories/base_home_repository.dart';
import '../data_source/base_remote_home_data_source.dart';

class HomeRepository extends BaseHomeRepository {
  final BaseRemoteHomeDataSource dataSource;

  HomeRepository(this.dataSource);

  final logger = Logger();

  @override
  Future<Either<ServerError, ProfileEntity>> getProfile() async {
    try {
      final result = await dataSource.getProfile();
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
  Future<Either<ServerError, bool>> activation() async {
    try {
      final result = await dataSource.activation();
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
  Future<Either<ServerError, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final result = await dataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, void>> editProfile({
    required String displayName,
    required String image,
  }) async {
    try {
      final result = await dataSource.editProfile(
        displayName: displayName,
        image: image,
      );
      return Right(result);
    } on DioException catch (fail) {
      return Left(ServerFailure.fromDiorError(fail));
    } catch (error) {
      logger.e(error);
      return Left(
        ServerFailure(error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerError, HomeCountEntity>> getHome() async {
    try {
      final result = await dataSource.getHome();
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
  Future<Either<ServerError, ReportCountEntity>> getReport() async {
    try {
      final result = await dataSource.getReport();
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
  Future<Either<ServerError, ReportCountEntity>> membersAttendanceCount({
    int? startDate,
    int? endDate,
    int? salaryType,
  }) async {
    try {
      final result = await dataSource.membersAttendanceCount(
        startDate: startDate,
        endDate: endDate,
        salaryType: salaryType,
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
  Future<Either<ServerError, List<MembersAttendanceEntity>>> membersAttendance({
    required int status,
    required int skip,
    int? startDate,
    int? endDate,
    int? salaryType,
  }) async {
    try {
      final result = await dataSource.membersAttendance(
        status: status,
        skip: skip,
        startDate: startDate,
        endDate: endDate,
        salaryType: salaryType,
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
