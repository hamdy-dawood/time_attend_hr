class CheckAttendanceModel {
  final bool success;
  final String message;

  CheckAttendanceModel({
    required this.success,
    required this.message,
  });

  factory CheckAttendanceModel.fromJson(Map<String, dynamic> json) {
    return CheckAttendanceModel(
      success: json["success"],
      message: json["message"],
    );
  }
}
