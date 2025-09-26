import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth_repository.dart';
import '../../cart/models/cart_storage.dart';
import 'profile_state.dart';

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

  Future<void> logout(BuildContext context) async {
    try {
      // Dialog xác nhận đăng xuất
      final confirmed = await _showLogoutConfirmDialog(context);
      if (!confirmed) return;

      emit(state.copyWith(isLoggingOut: true));

      // Xóa thông tin đăng nhập
      await AuthRepository.logoutKeepForm();

      // Xóa tất cả thông tin giỏ hàng
      await CartStorage.clearCart();

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      print('Lỗi logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Có lỗi xảy ra khi đăng xuất"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      emit(state.copyWith(isLoggingOut: false));
    }
  }

  Future<bool> _showLogoutConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Xác nhận đăng xuất",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          "Bạn có chắc chắn muốn đăng xuất?\nTất cả thông tin giỏ hàng sẽ bị xóa.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Hủy",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf24e1e),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
