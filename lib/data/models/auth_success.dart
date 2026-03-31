import 'package:shopito_app/data/models/user.dart';

class AuthSuccess {
  final User user;
  final String token;

  AuthSuccess({required this.user, required this.token});

  factory AuthSuccess.fromJson(Map<String, dynamic> json) {
    return AuthSuccess(user: User.fromJson(json['user']), token: json['token']);
  }
}
