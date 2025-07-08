class AddUsersEmployeeRequestBody {
  final String? id;
  final String username;
  final String password;
  final String displayName;
  final String image;
  final AddUsersEmployeePermissions? permissions;

  AddUsersEmployeeRequestBody({
    this.id,
    required this.username,
    required this.password,
    required this.displayName,
    required this.image,
    this.permissions,
  });
}

class AddUsersEmployeePermissions {
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

  AddUsersEmployeePermissions({
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
