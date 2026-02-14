import 'package:flutter/material.dart';

import '../../config/app_padding.dart';
import '../../config/app_styles.dart';
import '../custom_text.dart';


class MyTxtField extends StatelessWidget {
  const MyTxtField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const SizedBox(height: AppPadding.kPadding / 2),
        CustomText(title: title, fontWeight: AppFontWeight.w600),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

