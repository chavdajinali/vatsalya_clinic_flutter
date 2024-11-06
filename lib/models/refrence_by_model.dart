class RefrenceByModel {
  final List<String> options;

  RefrenceByModel({required this.options});

  factory RefrenceByModel.fromFirestore(List<dynamic> data) {
    return RefrenceByModel(
      options: List<String>.from(data),
    );
  }
}