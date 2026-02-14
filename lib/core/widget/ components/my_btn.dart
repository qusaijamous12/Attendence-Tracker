import 'package:flutter/material.dart';

import '../../config/app_color.dart';
import '../../config/app_styles.dart';
import '../custom_text.dart';

class MyBtn extends StatelessWidget {
  const MyBtn({super.key,required this.title,required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.kPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child:CustomText(
          title:  title,
          fontSize: AppFontSize.f16,
          fontWeight: AppFontWeight.w600,
          txtColor: Colors.white,
        ),
      ),
    );
  }
}
