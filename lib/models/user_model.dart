class UserModel {
  final String name;
  final String email;
  final String role;
  final String password;

  UserModel(
      {required this.name,
      required this.email,
      required this.role,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      role: json['role'] ?? "",
      password: json['password'] ?? "");

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'role': role, 'password': password};

  UserModel copyWith(
          {String? name, String? email, String? role, String? password}) =>
      UserModel(
          name: name ?? this.name,
          email: email ?? this.email,
          role: role ?? this.role,
          password: password ?? this.password);
}
