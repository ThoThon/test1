import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../widgets/footer_button.dart';
import '../widgets/input_field_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginScreenView(),
    );
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            _showErrorDialog(context, state.errorMessage);
          }
        },
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isLoginSuccess) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: context.read<LoginBloc>().formKey,
                  child: _buildBodyPage(context, state),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBodyPage(BuildContext context, LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIconLogo(),
        const SizedBox(height: 24),
        _buildTaxCode(context),
        const SizedBox(height: 24),
        _buildUserName(context),
        const SizedBox(height: 24),
        _buildPassword(context),
        const SizedBox(height: 30),
        _buttonLogin(context, state),
        const SizedBox(height: 200),
        _buildBottom(),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
      ],
    );
  }

  Widget _buildIconLogo() {
    return Container(
      padding: const EdgeInsets.only(top: 70, left: 16),
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 180,
        height: 50,
      ),
    );
  }

  Widget _buildTaxCode(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    return InputFieldBloc(
      label: "Mã số thuế",
      controller: bloc.taxController,
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
      hintText: 'Mã số thuế',
      clearIconAsset: 'assets/icons/blank.svg',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Mã số thuế không được để trống';
        }
        if (value.length != 10) {
          return 'Mã số thuế phải bao gồm 10 số';
        }
        return null;
      },
    );
  }

  Widget _buildUserName(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    return InputFieldBloc(
      label: "Tài khoản",
      controller: bloc.usernameController,
      hintText: 'Tài khoản',
      clearIconAsset: 'assets/icons/blank.svg',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Tài khoản không được để trống';
        }
        return null;
      },
    );
  }

  Widget _buildPassword(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    return InputFieldBloc(
      label: "Mật khẩu",
      controller: bloc.passwordController,
      hintText: 'Mật khẩu',
      showPassword: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Mật khẩu không được để trống';
        }
        if (value.length < 6 || value.length > 50) {
          return 'Mật khẩu chỉ từ 6 đến 50 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buttonLogin(BuildContext context, LoginState state) {
    final bloc = context.read<LoginBloc>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 400,
        height: 60,
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  if (!(bloc.formKey.currentState?.validate() ?? false)) return;
                  bloc.add(LoginSubmitted(
                    taxCode: bloc.taxController.text.trim(),
                    username: bloc.usernameController.text.trim(),
                    password: bloc.passwordController.text.trim(),
                  ));
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFf24e1e),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lỗi"),
          content: Text(
            message.isNotEmpty ? message : "Có lỗi xảy ra khi đăng nhập",
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFf24e1e),
              ),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FooterButton(
            svgAsset: 'assets/icons/headphone.svg',
            label: 'Trợ giúp',
            onTap: () => print('Trợ giúp được bấm'),
          ),
          FooterButton(
            svgAsset: 'assets/icons/facebook.svg',
            label: 'Group',
            onTap: () => print('Group được bấm'),
          ),
          FooterButton(
            svgAsset: 'assets/icons/search.svg',
            label: 'Tra cứu',
            onTap: () => print('Tra cứu được bấm'),
          ),
        ],
      ),
    );
  }
}
