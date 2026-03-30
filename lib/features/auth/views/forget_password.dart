import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/ components/my_btn.dart';
import '../../../core/widget/ components/my_txt_field.dart';

import '../../../core/widget/custom_text.dart';
import '../controller/login_controller.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _user=Get.find<LoginController>(tag: 'login_controller');
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {



    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  /// Back Button
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),

                  const SizedBox(height: 20),

                  /// Title Section
                  const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: 70,
                          color: AppColor.kPrimary,
                        ),
                        SizedBox(height: 16),
                        CustomText(
                          title: 'Forgot Password?',
                          fontSize: AppFontSize.f24,
                          fontWeight: AppFontWeight.bold,
                          txtColor: AppColor.kPrimary,
                        ),
                        SizedBox(height: 8),
                        CustomText(
                          title:
                          'Enter your email and we will send you a reset link',
                          fontSize: AppFontSize.f14,
                          txtColor: Colors.grey,
                          textAlign: TextAlign.center,
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
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  /// Send Button
                  MyBtn(
                    title: 'Send Reset Link',
                    onPressed: _submit,
                  ),

                  const Spacer(),

                  /// Back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Remember your password? '),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const CustomText(
                          title: 'Login',
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

  void _submit() async{
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      await _user.forgetPassword(email: email);
    }
  }
}
