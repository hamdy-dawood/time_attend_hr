import '../../domain/entities/report_count_entity.dart';

class ReportCountModel extends ReportCountEntity {
  ReportCountModel({
    required super.presentCount,
    required super.absentCount,
    required super.totalCount,
  });

  factory ReportCountModel.fromJson(Map<String, dynamic> json) {
    return ReportCountModel(
      presentCount: json['present'],
      absentCount: json['absent'],
      totalCount: json['total'],
    );
  }
}
