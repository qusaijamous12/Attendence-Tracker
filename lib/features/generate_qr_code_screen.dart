import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widget/custom_text.dart';
import 'home/data/lecture_model.dart';

class GenerateQRCodeScreen extends StatelessWidget {
  final LectureModel lecture;

  const GenerateQRCodeScreen({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final qrData = jsonEncode({
      'lectureId': lecture.id,
      'hash': lecture.qrHash,
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.kPrimary,
        title: const CustomText(
          title: 'Lecture QR Code',
          fontSize: AppFontSize.f20,
          fontWeight: AppFontWeight.bold,
          txtColor: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 250.0,
            ),
            const SizedBox(height: 24),
            CustomText(
              title: lecture.title,
              fontSize: AppFontSize.f18,
              fontWeight: AppFontWeight.bold,
            ),
            const SizedBox(height: 8),
            CustomText(
              title: 'Scheduled: ${lecture.dateTime.day}/${lecture.dateTime.month}/${lecture.dateTime.year} - ${lecture.dateTime.hour}:${lecture.dateTime.minute}',
              fontSize: AppFontSize.f14,
              txtColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  String generateLectureHash(String lectureId, DateTime dateTime) {
    return '$lectureId-${dateTime.millisecondsSinceEpoch}'.hashCode.toString();
  }
}
