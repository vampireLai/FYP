import 'dart:convert';
class Authentication {
  final String email;
  final String password;
  final String role;
  final String uuid;
  final List? modelData;

  Authentication(
      {required this.email,
      required this.password,
      required this.role,
      required this.uuid,
      this.modelData,
     });

  factory Authentication.fromMap(Map<String, dynamic> map) {
    return Authentication(
      email: map['email'],
      password: map['password'],
      role: map['role'],
      uuid: map['uuid'],
      modelData: jsonDecode(map['modelData']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'uuid': uuid,
      'modelData': jsonEncode(modelData),
    };
  }
}
