import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String taxCode;
  final String username;
  final String password;
  final bool isLoading;
  final String errorMessage;
  final bool isValid;
  final bool isLoginSuccess;

  const LoginState({
    this.taxCode = '',
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage = '',
    this.isValid = false,
    this.isLoginSuccess = false,
  });

  LoginState copyWith({
    String? taxCode,
    String? username,
    String? password,
    bool? isLoading,
    String? errorMessage,
    bool? isValid,
    bool? isLoginSuccess,
  }) {
    return LoginState(
      taxCode: taxCode ?? this.taxCode,
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
    );
  }

  @override
  List<Object> get props => [
        taxCode,
        username,
        password,
        isLoading,
        errorMessage,
        isValid,
        isLoginSuccess,
      ];
}
