class UsersEmployeesEntity {
  final String id;
  final String displayName;
  final String username;
  final List<String> roles;
  final bool active;
  final String timezone;
  final String image;
  final PermissionsEntity permissions;
  final String owner;
  final bool deleted;
  final int expiredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UsersEmployeesEntity({
    required this.id,
    required this.displayName,
    required this.username,
    required this.roles,
    required this.active,
    required this.timezone,
    required this.image,
    required this.permissions,
    required this.owner,
    required this.deleted,
    required this.expiredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
}

class PermissionsEntity {
  final bool showEmployeesPage;
  final bool showAttendancePage;
  final bool showAttendanceReportPage;
  final bool showFullReportPage;
  final bool showProjectsPage;
  final bool showHolidaysPage;
  final bool canRecognize;
  final bool canAdd;
  final bool canEdit;
  final bool canDelete;

  PermissionsEntity({
    required this.showEmployeesPage,
    required this.showAttendancePage,
    required this.showAttendanceReportPage,
    required this.showFullReportPage,
    required this.showProjectsPage,
    required this.showHolidaysPage,
    required this.canRecognize,
    required this.canAdd,
    required this.canEdit,
    required this.canDelete,
  });
}
