import 'package:equatable/equatable.dart';

class UserModel  extends Equatable {
  @override
  List<Object?> get props => [id, name, email, image, token];

  final String id;
  final String name;
  final String email;
  final String image;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['username'],
      email: json['email'],
      image: json['image'],
      token: json['token'],
    );
  }
}