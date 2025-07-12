import '../../domain/entities/login_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.accessToken,
    super.result,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json["token"],
      result: json["result"] != null ? ResultModel.fromJson(json["result"]) : null,
    );
  }
}

class ResultModel extends ResultEntity {
  ResultModel({
    required super.enrollId,
    required super.allowedMacs,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      enrollId: json['enrollId']?.toString() ?? '',
      allowedMacs: (json['allowed_macs'] as List<dynamic>?)
          ?.map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList() ??
          [],
    );
  }
}
