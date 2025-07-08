import 'package:time_attend_recognition/features/users/data/models/users_employees_model.dart';

import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.displayName,
    required super.username,
    required super.roles,
    required super.active,
    required super.timezone,
    required super.image,
    required super.permissions,
    required super.deleted,
    required super.expiredAt,
    required super.createdAt,
    required super.updatedAt,
    required super.v,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"],
      displayName: json["displayName"],
      username: json["username"],
      roles: List<String>.from(json["roles"].map((x) => x)),
      active: json["active"],
      timezone: json["timezone"],
      image: json["image"],
      permissions: PermissionsModel.fromJson(json['permissions']),
      deleted: json["deleted"],
      expiredAt: json["expiredAt"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "displayName": displayName,
      "username": username,
      "roles": List<dynamic>.from(roles.map((x) => x)),
      "active": active,
      "timezone": timezone,
      "image": image,
      "permissions": permissions,
      "deleted": deleted,
      "expiredAt": expiredAt,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}
