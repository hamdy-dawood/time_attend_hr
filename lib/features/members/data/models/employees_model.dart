import 'dart:typed_data';

import '../../domain/entities/employees_entity.dart';

class EmployeesModel extends EmployeesEntity {
  EmployeesModel({
    required super.id,
    required super.displayName,
    required super.enrollId,
    super.faceId,
  });

  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    return EmployeesModel(
      id: json["_id"],
      displayName: json["name"],
      enrollId: json["enroll_id"] ?? "",
      faceId: json['faceId'] != null ? Uint8List.fromList(List<int>.from(json['faceId']['data'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['displayName'] = displayName;
    data['faceId'] = faceId != null ? {'data': faceId!.toList()} : null;

    return data;
  }

  // Add this constructor to convert EmployeesEntity to EmployeesModel
  EmployeesModel.fromEntity(EmployeesEntity entity)
      : super(
          id: entity.id,
          displayName: entity.displayName,
          enrollId: entity.enrollId,
          faceId: entity.faceId,
        );
}
