import 'dart:typed_data';

class EmployeesEntity {
  final String id;
  final String displayName;
  final String enrollId;
  final Uint8List? faceId;

  EmployeesEntity({
    required this.id,
    required this.displayName,
    required this.enrollId,
    this.faceId,
  });
}
