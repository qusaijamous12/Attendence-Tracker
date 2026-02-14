import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/config/app_color.dart';
import '../../../core/widget/custom_text.dart';
import 'auth/controller/login_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QRScannerScreen extends StatefulWidget {
  final String? lectureId;
  const QRScannerScreen({super.key, this.lectureId});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}
class _QRScannerScreenState extends State<QRScannerScreen> {
  final loginController = Get.find<LoginController>(tag: 'login_controller');
  bool scanned = false;

  Future<void> _markAttendance(Map<String, dynamic> qrData) async {
    final student = loginController.userModel.value;
    if (student == null) return;

    final lectureId = qrData['lectureId'];
    final hash = qrData['hash'];

    final lectureRef =
    FirebaseFirestore.instance.collection('lectures').doc(lectureId);
    final lectureSnap = await lectureRef.get();

    if (!lectureSnap.exists || lectureSnap['qrHash'] != hash) {
      Get.snackbar(
        'Error',
        'Invalid QR code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Navigator.pop(context);
      return;
    }

    // ✅ use numeric weekday
    final todayWeekday = DateTime.now().weekday.toString();

    final lectureDays =
    List<String>.from(lectureSnap['daysOfWeek'] ?? []);

    if (!lectureDays.contains(todayWeekday)) {
      Get.snackbar(
        'Info',
        'This lecture is not scheduled for today',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      Navigator.pop(context);
      return;
    }

    // 🔥 SAFE attendance conversion
    final rawAttendance =
    Map<String, dynamic>.from(lectureSnap['attendancePerDay'] ?? {});

    final Map<String, List<String>> attendance = {};

    rawAttendance.forEach((key, value) {
      attendance[key] = List<String>.from(value ?? []);
    });

    final todayAttendance = attendance[todayWeekday] ?? [];

    if (!todayAttendance.contains(student.id)) {
      todayAttendance.add(student.id);
      attendance[todayWeekday] = todayAttendance;

      await lectureRef.update({'attendancePerDay': attendance});

      Get.snackbar(
        'Success',
        'Attendance marked for today',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Info',
        'You already attended today',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    Navigator.pop(context);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          title: 'Scan Lecture QR',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          txtColor: Colors.white,
        ),
        backgroundColor: AppColor.kPrimary,
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) async {
          if (!scanned) {
            scanned = true;
            try {
              final barcode = barcodeCapture.barcodes.first.rawValue;
              print('BAR CODE IS ${barcode}');
              final qrData = Map<String, dynamic>.from(jsonDecode(barcode!));
              print('QrData ${qrData}');
              await _markAttendance(qrData);
            } catch (e) {
              print('Error: ${e.toString()}');
              Get.snackbar(
                'Error',
                'Invalid QR code format',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}

