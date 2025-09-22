import 'package:hive/hive.dart';

part 'login_info.g.dart';

@HiveType(typeId: 0)
class LoginInfo {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String taxCode;

  @HiveField(3)
  final String token;

  LoginInfo({
    required this.username,
    required this.password,
    required this.taxCode,
    required this.token,
  });
}
