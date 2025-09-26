import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String userName;
  final String userTaxCode;
  final bool isLoggingOut;

  const ProfileState({
    this.userName = '',
    this.userTaxCode = '',
    this.isLoggingOut = false,
  });

  ProfileState copyWith({
    String? userName,
    String? userTaxCode,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      userTaxCode: userTaxCode ?? this.userTaxCode,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object> get props => [userName, userTaxCode, isLoggingOut];
}
