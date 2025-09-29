import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TextEditingController taxController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginBloc() : super(const LoginState()) {
    _loadSavedLoginInfo();
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _loadSavedLoginInfo() {
    final saved = AuthRepository.savedLoginInfo;
    if (saved != null) {
      taxController.text = saved.taxCode;
      usernameController.text = saved.username;
      passwordController.text = saved.password;
    }
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(state.copyWith(
        isLoading: true, errorMessage: '', isLoginSuccess: false));

    try {
      final success = await AuthRepository.login(
        taxCode: event.taxCode.trim(),
        username: event.username.trim(),
        password: event.password.trim(),
      );

      if (success) {
        emit(state.copyWith(isLoading: false, isLoginSuccess: true));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Đăng nhập thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Thông tin đăng nhập không hợp lệ",
      ));
    }
  }

  @override
  Future<void> close() {
    taxController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
