import '../../domain/entities/home_count_entity.dart';

class HomeCountModel extends HomeCountEntity {
  HomeCountModel({
    required super.employeesCount,
    required super.usersCount,
    required super.attendancesCount,
    required super.actionsCount,
    required super.projectsCount,
    required super.jobsCount,
    required super.holidaysCount,
  });

  factory HomeCountModel.fromJson(Map<String, dynamic> json) {
    return HomeCountModel(
      employeesCount: json["employees"]["count"],
      usersCount: json["users"]["count"],
      attendancesCount: json["attendances"]["count"],
      actionsCount: json["actions"]["count"],
      projectsCount: json["projects"]["count"],
      jobsCount: json["jobs"]["count"],
      holidaysCount: json["holidays"]["count"],
    );
  }
}
