import 'dart:typed_data';

import '../../domain/entities/employees_entity.dart';
import '../../domain/entities/subjects_entity.dart';

class SubjectsModel extends SubjectsEntity {
  SubjectsModel({
    required super.name,
    required super.code,
  });

  factory SubjectsModel.fromJson(Map<String, dynamic> json) {
    return SubjectsModel(
      name: json["name"],
      code: json["code"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}
