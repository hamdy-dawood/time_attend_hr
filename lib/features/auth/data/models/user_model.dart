import '../../domain/entities/login_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access_token": accessToken,
    };
  }
}
