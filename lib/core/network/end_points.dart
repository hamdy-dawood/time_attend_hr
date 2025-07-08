import '../caching/shared_prefs.dart';

class ApiConstants {
  static String cachedUrl() => Caching.get(key: "cached_url") ?? baseUrl;

  static String baseUrl = "http://65.20.133.8:8039";

  static String upload = "/upload/image";

  static String login = "/api/users/login";
  static String miniFace = "/api/employees/miniface";
  static String employees = "/api/employees";
  static String subjectsTeacher = "/api/subjects/teacher";
  static String fingerprint = "/api/fingerprints";

  static String refreshTokenUrl = "/auth/refresh-token";
  static String registerAdmin = "/auth/register-admin";
  static String registerUsersEmployee = "/auth/register-employee";
  static String loginEmployee = "/auth/login-employee";
  static String profile = "/auth/profile";
  static String editProfile = "/users/profile";
  static String changePassword = "/auth/change-password";

  static String checkUsername = "/users/isAvailable";
  static String send = "/otp/send";
  static String resend = "/otp/resend";

  static String activation = "/users/activation";
  static String homeCounts = "/counts";
  static String attendancePresentAbsenceReport = "/attendance/presence-absence-report";
  static String absentMembers = "/attendance/absent-members";
  static String presentMembers = "/attendance/present-members";

  static String attendanceCheck = "/attendance/check";

  static String attendance = "/attendance/";
  static String attendanceLogs = "/attendance/logs";
  static String attendanceCount = "/attendance/count";
  static String attendanceTotals = "/attendance/totals";

  static String members = "/members";
  static String membersCount = "/members/count";

  static String fullReport = "/attendance/full-report";

  static String projects = "/projects";
  static String projectsCount = "/projects/count";

  static String jobs = "/jobs";
  static String jobsCount = "/jobs/count";

  static String holidays = "/holidays";
  static String holidaysCount = "/holidays/count";

  static String usersEmployee = "/users/employees";
  static String usersEmployeeCount = "/users/employees/count";

  static String report = "/attendance/attendance-report";

  static String configUrl = "/config";
}
