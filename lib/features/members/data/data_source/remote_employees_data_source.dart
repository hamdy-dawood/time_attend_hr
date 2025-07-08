import 'package:dio/dio.dart';
import 'package:time_attend_recognition/core/network/dio.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';

import '../../domain/entities/add_employees_request_body.dart';
import '../models/employees_model.dart';
import '../models/subjects_model.dart';
import 'base_remote_employees_data_source.dart';

class RemoteMembersDataSource extends BaseRemoteEmployeesDataSource {
  final dioManager = DioManager();

  @override
  Future<List<EmployeesModel>> getEmployees({
    required String searchText,
  }) async {
    final Response response = await dioManager.get(
      ApiConstants.miniFace,
      // queryParameters: {
      //   if (searchText.isNotEmpty) "searchText": searchText,
      // },
    );

    return List<EmployeesModel>.from(response.data["data"].map((e) => EmployeesModel.fromJson(e)));
  }

  @override
  Future<EmployeesModel> addEmployees({
    required AddEmployeesRequestBody addMembersRequestBody,
  }) async {
    final Response response = await dioManager.post(
      ApiConstants.members,
      data: {
        "displayName": addMembersRequestBody.displayName,
        // "image": addMembersRequestBody.image,
        "faceId": addMembersRequestBody.faceId,
      },
    );

    return EmployeesModel.fromJson(response.data);
  }

  @override
  Future<EmployeesModel> editEmployees({
    required AddEmployeesRequestBody addMembersRequestBody,
  }) async {
    final Response response = await dioManager.put(
      "${ApiConstants.employees}/${addMembersRequestBody.id}",
      data: {
        "name": addMembersRequestBody.displayName,
        // "image": addMembersRequestBody.image,
        "faceId": addMembersRequestBody.faceId,
      },
    );
    return EmployeesModel.fromJson(response.data);
  }

  @override
  Future<void> deleteEmployees({required String id}) async {
    await dioManager.delete(
      "${ApiConstants.members}/$id",
    );
  }

  @override
  Future<List<SubjectsModel>> getSubjects({
    required String enrollId,
  }) async {
    final Response response = await dioManager.get(
      "${ApiConstants.subjectsTeacher}/$enrollId",
    );

    return List<SubjectsModel>.from(response.data.map((e) => SubjectsModel.fromJson(e)));
  }
}
