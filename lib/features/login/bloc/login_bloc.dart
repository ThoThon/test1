import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginStarted>(_onLoginStarted);
    on<LoginFormChanged>(_onLoginFormChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginStarted(LoginStarted event, Emitter<LoginState> emit) {
    // Load thông tin đã lưu từ storage
    final saved = AuthRepository.savedLoginInfo;
    if (saved != null) {
      emit(state.copyWith(
        taxCode: saved.taxCode,
        username: saved.username,
        password: saved.password,
        isValid: _isFormValid(saved.taxCode, saved.username, saved.password),
      ));
    }
  }

  void _onLoginFormChanged(LoginFormChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      taxCode: event.taxCode,
      username: event.username,
      password: event.password,
      errorMessage: '', // Clear error khi user thay đổi form
      isValid: _isFormValid(event.taxCode, event.username, event.password),
      isLoginSuccess: false, // Reset login success
    ));
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    // Validate form trước khi submit
    if (!_isFormValid(event.taxCode, event.username, event.password)) {
      emit(state.copyWith(
        errorMessage: "Vui lòng điền đầy đủ thông tin hợp lệ",
        isLoginSuccess: false,
      ));
      return;
    }

    // Bắt đầu loading
    emit(state.copyWith(
      isLoading: true,
      errorMessage: '',
      isLoginSuccess: false,
    ));

    try {
      // Gọi API login
      final success = await AuthRepository.login(
        taxCode: event.taxCode.trim(),
        username: event.username.trim(),
        password: event.password.trim(),
      );

      if (success) {
        emit(state.copyWith(
          isLoading: false,
          isLoginSuccess: true, // Đánh dấu thành công
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Đăng nhập thất bại",
          isLoginSuccess: false,
        ));
      }
    } catch (e) {
      print('Lỗi login: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Thông tin đăng nhập không hợp lệ",
        isLoginSuccess: false,
      ));
    }
  }

  bool _isFormValid(String taxCode, String username, String password) {
    return taxCode.trim().isNotEmpty &&
        taxCode.length == 10 &&
        username.trim().isNotEmpty &&
        password.trim().isNotEmpty &&
        password.length >= 6 &&
        password.length <= 50;
  }
}
