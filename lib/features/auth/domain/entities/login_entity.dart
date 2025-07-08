import '../../data/models/user_model.dart';

class UserEntity {
  String accessToken;

  UserEntity({
    required this.accessToken,
  });

  UserModel copyWith({
    String? id,
    String? accessToken,
    String? refreshToken,
    String? displayName,
    String? username,
  }) {
    return UserModel(
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
