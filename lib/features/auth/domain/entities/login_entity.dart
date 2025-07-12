class UserEntity {
  String accessToken;
  ResultEntity? result;

  UserEntity({
    required this.accessToken,
    this.result,
  });
}

class ResultEntity {
  String enrollId;
  List<String> allowedMacs;

  ResultEntity({
    required this.enrollId,
    required this.allowedMacs,
  });
}
