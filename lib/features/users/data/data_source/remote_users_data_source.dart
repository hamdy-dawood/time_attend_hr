import 'package:dio/dio.dart';
import 'package:time_attend_recognition/core/network/dio.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';

import '../../domain/entities/add_users_employee_request_body.dart';
import '../models/users_employees_model.dart';
import 'base_remote_users_data_source.dart';

class RemoteUsersEmployeesDataSource extends BaseRemoteUsersEmployeesDataSource {
  final dioManager = DioManager();

  @override
  Future<int> count() async {
    final Response response = await dioManager.get(
      ApiConstants.usersEmployeeCount,
    );

    return response.data["count"];
  }

  @override
  Future<List<UsersEmployeesModel>> getUsersEmployees({
    required int skip,
    required String searchText,
  }) async {
    final Response response = await dioManager.get(
      ApiConstants.usersEmployee,
      queryParameters: {
        "skip": skip * 20,
        if (searchText.isNotEmpty) "searchText": searchText,
      },
    );

    return List<UsersEmployeesModel>.from(response.data.map((e) => UsersEmployeesModel.fromJson(e)));
  }

  @override
  Future<void> addUsersEmployees({
    required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody,
  }) async {
    await dioManager.post(
      ApiConstants.registerUsersEmployee,
      data: {
        "username": addUsersEmployeeRequestBody.username,
        "password": addUsersEmployeeRequestBody.password,
        "displayName": addUsersEmployeeRequestBody.displayName,
        "image": addUsersEmployeeRequestBody.image,
        "permissions": {
          "showEmployeesPage": addUsersEmployeeRequestBody.permissions!.showEmployeesPage,
          "showAttendancePage": addUsersEmployeeRequestBody.permissions!.showAttendancePage,
          "showAttendanceReportPage": addUsersEmployeeRequestBody.permissions!.showAttendanceReportPage,
          "showFullReportPage": addUsersEmployeeRequestBody.permissions!.showFullReportPage,
          "showProjectsPage": addUsersEmployeeRequestBody.permissions!.showProjectsPage,
          "showHolidaysPage": addUsersEmployeeRequestBody.permissions!.showHolidaysPage,
          "canRecognize": addUsersEmployeeRequestBody.permissions!.canRecognize,
          "canAdd": addUsersEmployeeRequestBody.permissions!.canAdd,
          "canEdit": addUsersEmployeeRequestBody.permissions!.canEdit,
          "canDelete": addUsersEmployeeRequestBody.permissions!.canDelete,
        },
      },
    );
  }

  @override
  Future<void> editUsersEmployees({
    required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody,
  }) async {
    await dioManager.put(
      "${ApiConstants.usersEmployee}/${addUsersEmployeeRequestBody.id}",
      data: {
        "username": addUsersEmployeeRequestBody.username,
        "password": addUsersEmployeeRequestBody.password,
        "displayName": addUsersEmployeeRequestBody.displayName,
        "image": addUsersEmployeeRequestBody.image,
        "permissions": {
          "showEmployeesPage": addUsersEmployeeRequestBody.permissions!.showEmployeesPage,
          "showAttendancePage": addUsersEmployeeRequestBody.permissions!.showAttendancePage,
          "showAttendanceReportPage": addUsersEmployeeRequestBody.permissions!.showAttendanceReportPage,
          "showFullReportPage": addUsersEmployeeRequestBody.permissions!.showFullReportPage,
          "showProjectsPage": addUsersEmployeeRequestBody.permissions!.showProjectsPage,
          "showHolidaysPage": addUsersEmployeeRequestBody.permissions!.showHolidaysPage,
          "canRecognize": addUsersEmployeeRequestBody.permissions!.canRecognize,
          "canAdd": addUsersEmployeeRequestBody.permissions!.canAdd,
          "canEdit": addUsersEmployeeRequestBody.permissions!.canEdit,
          "canDelete": addUsersEmployeeRequestBody.permissions!.canDelete,
        },
      },
    );
  }

  @override
  Future<void> deleteUsersEmployees({required String id}) async {
    await dioManager.delete(
      "${ApiConstants.usersEmployee}/$id",
    );
  }
}
