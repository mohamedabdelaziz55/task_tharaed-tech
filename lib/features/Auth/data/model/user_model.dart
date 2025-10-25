class UserModel {
  final String? token;
  final String username;
  final String email;
  final String? image;
  final int? otp;

  UserModel({
    this.token,
    required this.username,
    required this.email,
    this.image,
    this.otp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UserModel(
      token: data['token'],
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      image: data['image'],
      otp: data['otp'],
    );
  }

  /// ✅ لتحويل الـ model إلى Map (مفيد عند الحفظ في SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'email': email,
      'image': image,
      'otp': otp,
    };
  }

  /// ✅ لعمل نسخة جديدة مع تعديل بعض القيم فقط
  UserModel copyWith({
    String? token,
    String? username,
    String? email,
    String? image,
    int? otp,
  }) {
    return UserModel(
      token: token ?? this.token,
      username: username ?? this.username,
      email: email ?? this.email,
      image: image ?? this.image,
      otp: otp ?? this.otp,
    );
  }
}
