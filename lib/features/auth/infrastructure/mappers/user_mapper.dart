import '../../domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    final user = User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      token: json['token'],
    );
    return user;
  }
}
