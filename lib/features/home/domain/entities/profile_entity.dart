import 'package:time_attend_recognition/features/users/data/models/users_employees_model.dart';

class ProfileEntity {
  String id;
  String displayName;
  String username;
  List<String> roles;
  bool active;
  String timezone;
  String image;
  PermissionsModel permissions;
  bool deleted;
  int expiredAt;
  String createdAt;
  String updatedAt;
  int v;

  ProfileEntity({
    required this.id,
    required this.displayName,
    required this.username,
    required this.roles,
    required this.active,
    required this.timezone,
    required this.image,
    required this.permissions,
    required this.deleted,
    required this.expiredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
}
