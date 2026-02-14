import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/ components/my_btn.dart';
import '../../../core/widget/ components/my_txt_field.dart';
import '../../../core/widget/custom_text.dart';
import '../controller/login_controller.dart';
import 'register_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginController = Get.find<LoginController>(tag: 'login_controller');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _loginController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  /// Logo & Title
                  const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 70,
                          color: AppColor.kPrimary,
                        ),
                        SizedBox(height: 16),
                        CustomText(
                          title: 'Attendance Tracker',
                          fontSize: AppFontSize.f24,
                          fontWeight: AppFontWeight.bold,
                          txtColor: AppColor.kPrimary,
                        ),
                        SizedBox(height: 8),
                        CustomText(
                          title: 'Sign in to continue',
                          fontSize: AppFontSize.f14,
                          txtColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// Email Field
                  MyTxtField(
                    title: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Your University Email',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email cannot be empty';
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Password Field
                  MyTxtField(
                    title: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password cannot be empty';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const CustomText(
                        title: 'Forgot Password?',
                        fontSize: AppFontSize.f14,
                        txtColor: AppColor.kPrimary,
                        fontWeight: AppFontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Login Button with Loader
                  Obx(() {
                    if (_loginController.loginStatus.value ==
                        RequestStatus.loading) {
                      return const Center(child: CircularProgressIndicator(color: AppColor.kPrimary,));
                    }
                    return MyBtn(title: 'Login', onPressed: _login);
                  }),

                  const Spacer(),

                  /// Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Get.off(() => const RegisterView()),
                        child: const CustomText(
                          title: 'Register',
                          txtColor: AppColor.kPrimary,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
