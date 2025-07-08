import '../../domain/entities/users_employees_entity.dart';

class UsersEmployeesModel extends UsersEmployeesEntity {
  UsersEmployeesModel({
    required super.id,
    required super.displayName,
    required super.username,
    required super.roles,
    required super.active,
    required super.timezone,
    required super.image,
    required super.permissions,
    required super.owner,
    required super.deleted,
    required super.expiredAt,
    required super.createdAt,
    required super.updatedAt,
    required super.v,
  });

  factory UsersEmployeesModel.fromJson(Map<String, dynamic> json) {
    return UsersEmployeesModel(
      id: json["_id"],
      displayName: json["displayName"],
      username: json["username"],
      roles: List<String>.from(json["roles"].map((x) => x)),
      active: json["active"],
      timezone: json["timezone"],
      image: json["image"],
      permissions: PermissionsModel.fromJson(json['permissions']),
      owner: json["owner"],
      deleted: json["deleted"],
      expiredAt: json["expiredAt"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }
}

class PermissionsModel extends PermissionsEntity {
  PermissionsModel({
    required super.showEmployeesPage,
    required super.showAttendancePage,
    required super.showAttendanceReportPage,
    required super.showFullReportPage,
    required super.showProjectsPage,
    required super.showHolidaysPage,
    required super.canRecognize,
    required super.canAdd,
    required super.canEdit,
    required super.canDelete,
  });

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      showEmployeesPage: json["showEmployeesPage"],
      showAttendancePage: json["showAttendancePage"],
      showAttendanceReportPage: json["showAttendanceReportPage"] ?? false,
      showFullReportPage: json["showFullReportPage"],
      showProjectsPage: json["showProjectsPage"],
      showHolidaysPage: json["showHolidaysPage"],
      canRecognize: json["canRecognize"],
      canAdd: json["canAdd"],
      canEdit: json["canEdit"],
      canDelete: json["canDelete"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "showEmployeesPage": showEmployeesPage,
      "showAttendancePage": showAttendancePage,
      "showAttendanceReportPage": showAttendanceReportPage,
      "showFullReportPage": showFullReportPage,
      "showProjectsPage": showProjectsPage,
      "showHolidaysPage": showHolidaysPage,
      "canRecognize": canRecognize,
      "canAdd": canAdd,
      "canEdit": canEdit,
      "canDelete": canDelete,
    };
  }
}
