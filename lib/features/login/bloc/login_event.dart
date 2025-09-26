import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String taxCode;
  final String username;
  final String password;

  const LoginSubmitted({
    required this.taxCode,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [taxCode, username, password];
}
