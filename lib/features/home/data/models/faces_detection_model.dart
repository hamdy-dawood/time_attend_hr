class FacesDetectionModel {
  final String id;
  final bool uploadedToServer;
  final String memberId;
  final String memberName;
  final String openTime;
  final String closeTime;
  final String projectId;
  final String projectName;
  final String serverReplay;
  final String createdAt;

  FacesDetectionModel({
    required this.id,
    required this.uploadedToServer,
    required this.memberId,
    required this.memberName,
    required this.openTime,
    required this.closeTime,
    required this.projectId,
    required this.projectName,
    required this.serverReplay,
    required this.createdAt,
  });

  factory FacesDetectionModel.fromJson(Map<String, dynamic> json) {
    return FacesDetectionModel(
      id: json["id"],
      uploadedToServer: json["uploadedToServer"],
      memberId: json["memberId"],
      memberName: json["memberName"],
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      projectId: json["projectId"],
      projectName: json["projectName"],
      serverReplay: json["serverReplay"] ?? "",
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uploadedToServer": uploadedToServer,
      "memberId": memberId,
      "memberName": memberName,
      "openTime": openTime,
      "closeTime": closeTime,
      "projectId": projectId,
      "projectName": projectName,
      "serverReplay": serverReplay,
      "createdAt": createdAt,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
