import '../models/home_count_model.dart';
import '../models/members_attendance_model.dart';
import '../models/profile_model.dart';
import '../models/report_count_model.dart';

abstract class BaseRemoteHomeDataSource {
  Future<ProfileModel> getProfile();

  Future<bool> activation();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> editProfile({
    required String displayName,
    required String image,
  });

  Future<HomeCountModel> getHome();

  Future<ReportCountModel> getReport();

  Future<ReportCountModel> membersAttendanceCount({
    int? startDate,
    int? endDate,
    int? salaryType,
  });

  Future<List<MembersAttendanceModel>> membersAttendance({
    required int status,
    required int skip,
    int? startDate,
    int? endDate,
    int? salaryType,
  });
}
