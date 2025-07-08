import '../../domain/entities/members_attendance_entity.dart';

class MembersAttendanceModel extends MembersAttendanceEntity {
  MembersAttendanceModel({
    required super.id,
    required super.displayName,
    required super.image,
  });

  factory MembersAttendanceModel.fromJson(Map<String, dynamic> json) {
    return MembersAttendanceModel(
      id: json["_id"],
      displayName: json["displayName"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "displayName": displayName,
      "image": image,
    };
  }
}
