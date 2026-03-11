import 'dart:convert';

class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? image;
  final String token;
  final String? refreshToken;

  const UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    required this.token,
    this.refreshToken,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      token: json['accessToken'] ?? json['token'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'accessToken': token,
      'refreshToken': refreshToken,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String jsonStr) {
    return UserModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }
}
