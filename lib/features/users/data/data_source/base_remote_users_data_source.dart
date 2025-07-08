import '../../domain/entities/add_users_employee_request_body.dart';
import '../models/users_employees_model.dart';

abstract class BaseRemoteUsersEmployeesDataSource {
  Future<int> count();

  Future<List<UsersEmployeesModel>> getUsersEmployees({
    required int skip,
    required String searchText,
  });

  Future<void> addUsersEmployees({required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody});

  Future<void> editUsersEmployees({required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody});

  Future<void> deleteUsersEmployees({required String id});
}
