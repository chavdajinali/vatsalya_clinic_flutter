class RefrenceModel {
  late String id;
  final String  name;

  RefrenceModel({required this.id,required this.name});

  factory RefrenceModel.fromJson(Map<String, dynamic> json) => RefrenceModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "");

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name
  };

  RefrenceModel copyWith(
      {String? id,
        String? name}) =>
      RefrenceModel(
          id: id ?? this.id,
          name: name ?? this.name);
}