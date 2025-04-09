
class ReportNameAddModel {
  late String id;
  late String report_name;

  ReportNameAddModel(
      {required this.id,
        required this.report_name});

  factory ReportNameAddModel.fromJson(Map<String, dynamic> json) => ReportNameAddModel(
      id: json['id'] ?? "",
      report_name: json['report_name'] ?? "");

  Map<String, dynamic> toJson() => {
    'id': id,
    'report_name': report_name
  };

  ReportNameAddModel copyWith(
      {String? id,
        String? report_name}) =>
      ReportNameAddModel(
          id: id ?? this.id,
          report_name: report_name ?? this.report_name);
}
