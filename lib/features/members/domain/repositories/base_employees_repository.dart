import 'package:dartz/dartz.dart';
import 'package:time_attend_recognition/core/errors/server_errors.dart';

import '../entities/add_employees_request_body.dart';
import '../entities/employees_entity.dart';
import '../entities/subjects_entity.dart';

abstract class BaseEmployeesRepository {
  Future<Either<ServerError, List<EmployeesEntity>>> getEmployees({required String searchText});

  Future<Either<ServerError, EmployeesEntity>> addEmployees({required AddEmployeesRequestBody addMembersRequestBody});

  Future<Either<ServerError, EmployeesEntity>> editEmployees({required AddEmployeesRequestBody addMembersRequestBody});

  Future<Either<ServerError, void>> deleteEmployees({required String id});

  Future<Either<ServerError, List<SubjectsEntity>>> getSubjects({required String enrollId});
}
