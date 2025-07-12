import 'package:dartz/dartz.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../entities/home_count_entity.dart';
import '../entities/members_attendance_entity.dart';
import '../entities/profile_entity.dart';
import '../entities/report_count_entity.dart';

abstract class BaseHomeRepository {
  Future<Either<ServerError, dynamic>> qrAttendance({
    required String token,
  });

  Future<Either<ServerError, ProfileEntity>> getProfile();

  Future<Either<ServerError, bool>> activation();

  Future<Either<ServerError, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<ServerError, void>> editProfile({
    required String displayName,
    required String image,
  });

  Future<Either<ServerError, HomeCountEntity>> getHome();

  Future<Either<ServerError, ReportCountEntity>> getReport();

  Future<Either<ServerError, ReportCountEntity>> membersAttendanceCount({
    int? startDate,
    int? endDate,
    int? salaryType,
  });

  Future<Either<ServerError, List<MembersAttendanceEntity>>> membersAttendance({
    required int status,
    required int skip,
    int? startDate,
    int? endDate,
    int? salaryType,
  });
}
