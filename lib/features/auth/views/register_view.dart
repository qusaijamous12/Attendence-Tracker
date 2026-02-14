import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/ components/my_btn.dart';
import '../../../core/widget/ components/my_txt_field.dart';

import '../../../core/widget/custom_text.dart';
import '../controller/login_controller.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final  _loginController = Get.find<LoginController>(tag: 'login_controller');
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Center(
                    child: Column(
                      children:  [
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
                          title: 'Create your student account',
                          fontSize: AppFontSize.f14,
                          txtColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),


                  MyTxtField(
                    title: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person),
                  ),

                  const SizedBox(height: 20),


                  MyTxtField(
                    title: 'Email',
                    hintText: 'Enter your university email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
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
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  Obx(
                        () {
                      if (_loginController.registerStatus.value == RequestStatus.loading) {
                        return const Center(child: CircularProgressIndicator(color: AppColor.kPrimary,));
                      }
                      return MyBtn(
                        title: 'Register',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginController.register(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              fullName: _nameController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),


                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () => Get.off(() => const LoginView()),
                        child: const CustomText(
                          title: 'Login',
                          txtColor: AppColor.kPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
