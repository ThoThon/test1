import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String userName;
  final String userTaxCode;
  final bool isLoggingOut;
  final bool showLogoutDialog;
  final bool logoutSuccess;

  const ProfileState({
    this.userName = '',
    this.userTaxCode = '',
    this.isLoggingOut = false,
    this.showLogoutDialog = false,
    this.logoutSuccess = false,
  });

  ProfileState copyWith({
    String? userName,
    String? userTaxCode,
    bool? isLoggingOut,
    bool? showLogoutDialog,
    bool? logoutSuccess,
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      userTaxCode: userTaxCode ?? this.userTaxCode,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      showLogoutDialog: showLogoutDialog ?? this.showLogoutDialog,
      logoutSuccess: logoutSuccess ?? this.logoutSuccess,
    );
  }

  @override
  List<Object> get props => [
        userName,
        userTaxCode,
        isLoggingOut,
        showLogoutDialog,
        logoutSuccess,
      ];
}
