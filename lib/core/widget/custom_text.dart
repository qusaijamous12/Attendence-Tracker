import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_styles.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.title,
    this.fontSize = AppFontSize.f16,
    this.fontWeight = AppFontWeight.w400,
    this.txtColor = Colors.black,
    this.textAlign = TextAlign.start,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color txtColor;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign:textAlign ,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: txtColor,

      ),
    );
  }
}
