import '../../domain/entities/add_employees_request_body.dart';
import '../models/employees_model.dart';
import '../models/subjects_model.dart';

abstract class BaseRemoteEmployeesDataSource {
  Future<List<EmployeesModel>> getEmployees({required String searchText});

  Future<EmployeesModel> addEmployees({required AddEmployeesRequestBody addMembersRequestBody});

  Future<EmployeesModel> editEmployees({required AddEmployeesRequestBody addMembersRequestBody});

  Future<void> deleteEmployees({required String id});

  Future<List<SubjectsModel>> getSubjects({required String enrollId});
}
