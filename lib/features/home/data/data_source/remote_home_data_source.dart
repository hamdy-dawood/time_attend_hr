import 'package:dio/dio.dart';
import 'package:time_attend_recognition/core/network/dio.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';
import 'package:time_attend_recognition/features/home/data/models/profile_model.dart';

import '../models/home_count_model.dart';
import '../models/members_attendance_model.dart';
import '../models/report_count_model.dart';
import 'base_remote_home_data_source.dart';

class RemoteHomeDataSource extends BaseRemoteHomeDataSource {
  final dioManager = DioManager();

  @override
  Future<ProfileModel> getProfile() async {
    final Response response = await dioManager.get(
      ApiConstants.profile,
    );

    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<bool> activation() async {
    final Response response = await dioManager.get(
      ApiConstants.activation,
    );

    return response.data["active"];
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await dioManager.post(
      ApiConstants.changePassword,
      data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },
    );
  }

  @override
  Future<void> editProfile({
    required String displayName,
    required String image,
  }) async {
    await dioManager.put(
      ApiConstants.editProfile,
      data: {
        "displayName": displayName,
        "image": image,
      },
    );
  }

  @override
  Future<HomeCountModel> getHome() async {
    final Response response = await dioManager.get(
      ApiConstants.homeCounts,
    );

    return HomeCountModel.fromJson(response.data);
  }

  @override
  Future<ReportCountModel> getReport() async {
    DateTime now = DateTime.now();

    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    int startDateMilliseconds = startOfDay.millisecondsSinceEpoch;
    int endDateMilliseconds = endOfDay.millisecondsSinceEpoch;

    final Response response = await dioManager.get(
      ApiConstants.attendancePresentAbsenceReport,
      queryParameters: {
        "startDate": startDateMilliseconds,
        "endDate": endDateMilliseconds,
      },
    );

    return ReportCountModel.fromJson(response.data);
  }

  @override
  Future<ReportCountModel> membersAttendanceCount({
    int? startDate,
    int? endDate,
    int? salaryType,
  }) async {
    final Response response = await dioManager.get(
      ApiConstants.attendancePresentAbsenceReport,
    );

    return ReportCountModel.fromJson(response.data);
  }

  @override
  Future<List<MembersAttendanceModel>> membersAttendance({
    required int status,
    required int skip,
    int? startDate,
    int? endDate,
    int? salaryType,
  }) async {
    DateTime now = DateTime.now();

    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    int startDateMilliseconds = startOfDay.millisecondsSinceEpoch;
    int endDateMilliseconds = endOfDay.millisecondsSinceEpoch;

    final response = await dioManager.get(
      status == 0 ? ApiConstants.absentMembers : ApiConstants.presentMembers,
      queryParameters: {
        "skip": skip * 20,
        "startDate": startDate ?? startDateMilliseconds,
        "endDate": endDate ?? endDateMilliseconds,
        if (salaryType != null && salaryType != -1) "salaryType": salaryType,
      },
    );

    return List<MembersAttendanceModel>.from(response.data.map((e) => MembersAttendanceModel.fromJson(e)));
  }
}
