import 'package:hive/hive.dart';

import 'login_info.dart';

class LoginStorage {
  static const String boxName = 'loginBox';
  static const String keyUserLogin = 'user_login';

  static Box<LoginInfo> get _box => Hive.box<LoginInfo>(boxName);

  static Future<void> saveLoginInfo(LoginInfo info) async {
    print("Save token: ${info.token}"); // debug

    await _box.put(keyUserLogin, info);
  }

  static LoginInfo? getLoginInfo() {
    return _box.get(keyUserLogin);
  }

  static String? getToken() {
    final info = getLoginInfo();
    return info?.token;
  }

  // Chỉ xóa token, giữ lại thông tin form
  static Future<void> clearLoginInfo() async {
    final currentInfo = getLoginInfo();
    if (currentInfo != null) {
      final formInfo = LoginInfo(
        username: currentInfo.username,
        password: currentInfo.password,
        taxCode: currentInfo.taxCode,
        token: '',
      );
      await _box.put(keyUserLogin, formInfo);
    }
  }

  // Xóa hoàn toàn tất cả thông tin
  static Future<void> clearAllInfo() async {
    await _box.delete(keyUserLogin);
  }

  static bool get isLoggedIn {
    final info = getLoginInfo();
    return info != null &&
        info.username.trim().isNotEmpty &&
        info.password.trim().isNotEmpty &&
        info.taxCode.trim().isNotEmpty &&
        info.token.trim().isNotEmpty;
  }
}
