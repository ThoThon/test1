import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesst_bloc/features/profile/cubit/profile_state.dart';
import 'package:tesst_bloc/repositories/auth_repository.dart';

import '../../cart/models/cart_storage.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState()) {
    loadUserInfo();
  }

  void loadUserInfo() {
    final loginInfo = AuthRepository.savedLoginInfo;
    if (loginInfo != null) {
      emit(state.copyWith(
        userName: loginInfo.username,
        userTaxCode: loginInfo.taxCode,
      ));
    }
  }

  void requestLogout() {
    emit(state.copyWith(showLogoutDialog: true));
  }

  void dialogShown() {
    emit(state.copyWith(showLogoutDialog: false));
  }

  Future<void> confirmLogout() async {
    try {
      emit(state.copyWith(isLoggingOut: true));

      // Xóa thông tin đăng nhập
      await AuthRepository.logoutKeepForm();

      // Xóa tất cả thông tin giỏ hàng
      await CartStorage.clearCart();

      // Emit success để UI navigate
      emit(state.copyWith(
        isLoggingOut: false,
        logoutSuccess: true,
      ));
    } catch (e) {
      print('Lỗi logout: $e');
      emit(state.copyWith(
        isLoggingOut: false,
        logoutSuccess: false,
      ));
    }
  }

  void resetLogoutSuccess() {
    emit(state.copyWith(logoutSuccess: false));
  }
}
