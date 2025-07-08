import 'package:dartz/dartz.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../../data/models/users_employees_model.dart';
import '../entities/add_users_employee_request_body.dart';

abstract class BaseUsersEmployeesRepository {
  Future<Either<ServerError, int>> count();

  Future<Either<ServerError, List<UsersEmployeesModel>>> getUsersEmployees({
    required int skip,
    required String searchText,
  });

  Future<Either<ServerError, void>> addUsersEmployees({required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody});

  Future<Either<ServerError, void>> editUsersEmployees({required AddUsersEmployeeRequestBody addUsersEmployeeRequestBody});

  Future<Either<ServerError, void>> deleteUsersEmployees({required String id});
}
