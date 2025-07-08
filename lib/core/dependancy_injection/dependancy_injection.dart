import 'package:get_it/get_it.dart';
import 'package:time_attend_recognition/features/auth/data/data_source/base_remote_auth_data_source.dart';
import 'package:time_attend_recognition/features/auth/data/data_source/remote_auth_data_source.dart';
import 'package:time_attend_recognition/features/auth/data/repo/auth_repository.dart';
import 'package:time_attend_recognition/features/auth/domain/repository/base_auth_repository.dart';
import 'package:time_attend_recognition/features/auth/presentation/cubit/login_cubit.dart';
import 'package:time_attend_recognition/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:time_attend_recognition/features/home/data/data_source/base_remote_home_data_source.dart';
import 'package:time_attend_recognition/features/home/data/data_source/remote_home_data_source.dart';
import 'package:time_attend_recognition/features/home/data/repo/home_repository.dart';
import 'package:time_attend_recognition/features/home/domain/repositories/base_home_repository.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
import 'package:time_attend_recognition/features/members/data/data_source/base_remote_employees_data_source.dart';
import 'package:time_attend_recognition/features/members/data/data_source/remote_employees_data_source.dart';
import 'package:time_attend_recognition/features/members/data/repo/employees_repository.dart';
import 'package:time_attend_recognition/features/members/domain/repositories/base_employees_repository.dart';
import 'package:time_attend_recognition/features/members/presentation/cubit/employees_cubit.dart';
import 'package:time_attend_recognition/features/users/data/data_source/base_remote_users_data_source.dart';
import 'package:time_attend_recognition/features/users/data/data_source/remote_users_data_source.dart';
import 'package:time_attend_recognition/features/users/data/repo/users_repository.dart';
import 'package:time_attend_recognition/features/users/domain/repositories/base_users_repository.dart';
import 'package:time_attend_recognition/features/users/presentation/cubit/users_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // auth
  getIt.registerLazySingleton<BaseRemoteAuthDataSource>(() => RemoteAuthDataSource());
  getIt.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(getIt()));
  getIt.registerFactory<LogInCubit>(() => LogInCubit(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));

  // Home
  getIt.registerLazySingleton<BaseRemoteHomeDataSource>(() => RemoteHomeDataSource());
  getIt.registerLazySingleton<BaseHomeRepository>(() => HomeRepository(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // Members
  getIt.registerLazySingleton<BaseRemoteEmployeesDataSource>(() => RemoteMembersDataSource());
  getIt.registerLazySingleton<BaseEmployeesRepository>(() => EmployeesRepository(getIt()));
  getIt.registerFactory<EmployeesCubit>(() => EmployeesCubit(getIt()));

  // Users Employees
  getIt.registerLazySingleton<BaseRemoteUsersEmployeesDataSource>(() => RemoteUsersEmployeesDataSource());
  getIt.registerLazySingleton<BaseUsersEmployeesRepository>(() => UsersEmployeesRepository(getIt()));
  getIt.registerFactory<UsersEmployeesCubit>(() => UsersEmployeesCubit(getIt()));

}
