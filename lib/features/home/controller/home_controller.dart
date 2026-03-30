import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/login_controller.dart';
import '../data/lecture_model.dart';

class HomeController extends GetxController {
  final loginController = Get.find<LoginController>(tag: 'login_controller');

  final createLectureStatus = Rx<RequestStatus>(RequestStatus.initial);
  final lecturesStatus = Rx<RequestStatus>(RequestStatus.initial);

  final _firebaseInstance = FirebaseFirestore.instance;

  final doctorLectures = <LectureModel>[].obs;
  final studentLectures = <LectureModel>[].obs;

  Future<void> createLecture({
    required String title,
    required String courseCode,
    required String section,
    required String room,
    required DateTime dateTime,
    required List<String> daysOfWeek,
  }) async {
    createLectureStatus.value = RequestStatus.loading;

    try {
      final doctor = loginController.userModel.value;
      if (doctor == null) {
        createLectureStatus.value = RequestStatus.error;
        Get.snackbar(
          'Error',
          'Doctor not logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final docRef = _firebaseInstance.collection('lectures').doc();
      final qrHash = '${docRef.id}-${DateTime.now().millisecondsSinceEpoch}';

      final attendance = <String, List<String>>{};
      for (final day in daysOfWeek) {
        attendance[day] = [];
      }

      await docRef.set({
        'title': title.trim(),
        'courseCode': courseCode.trim(),
        'section': section.trim(),
        'room': room.trim(),
        'doctorId': doctor.id,
        'dateTime': dateTime,
        'students': <String>[],
        'attendancePerDay': attendance,
        'daysOfWeek': daysOfWeek,
        'qrHash': qrHash,
      });

      createLectureStatus.value = RequestStatus.success;
      Get.snackbar(
        'Success',
        'Lecture created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

      await getDoctorLectures();
    } catch (e) {
      createLectureStatus.value = RequestStatus.error;
      Get.snackbar(
        'Error',
        'Failed to create lecture',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('$e');
    }
  }

  Future<void> getDoctorLectures() async {
    lecturesStatus.value = RequestStatus.loading;

    try {
      final doctor = loginController.userModel.value;
      if (doctor == null) {
        lecturesStatus.value = RequestStatus.error;
        Get.snackbar(
          'Error',
          'Doctor not logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
        );
        return;
      }

      final querySnapshot = await _firebaseInstance
          .collection('lectures')
          .where('doctorId', isEqualTo: doctor.id)
          .orderBy('dateTime', descending: true)
          .get();

      doctorLectures.assignAll(
        querySnapshot.docs
            .map((doc) => LectureModel.fromJson(doc.data(), doc.id))
            .toList(),
      );
      lecturesStatus.value = RequestStatus.success;
    } catch (e) {
      lecturesStatus.value = RequestStatus.error;
      Get.snackbar(
        'Error',
        'Failed to fetch lectures',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      debugPrint('error is ${e.toString()}');
    }
  }

  Future<void> getStudentLectures() async {
    lecturesStatus.value = RequestStatus.loading;

    try {
      final student = loginController.userModel.value;
      if (student == null) {
        lecturesStatus.value = RequestStatus.error;
        Get.snackbar(
          'Error',
          'Student not logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
        );
        return;
      }

      final querySnapshot = await _firebaseInstance
          .collection('lectures')
          .where('students', arrayContains: student.id)
          .orderBy('dateTime', descending: true)
          .get();

      studentLectures.assignAll(
        querySnapshot.docs
            .map((doc) => LectureModel.fromJson(doc.data(), doc.id))
            .toList(),
      );
      lecturesStatus.value = RequestStatus.success;
    } catch (e) {
      lecturesStatus.value = RequestStatus.error;
      Get.snackbar(
        'Error',
        'Failed to fetch lectures',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      debugPrint('error is ${e.toString()}');
    }
  }

  int getTodayAttendanceCount(LectureModel lecture) {
    final todayKey = DateTime.now().weekday.toString();
    return lecture.attendancePerDay[todayKey]?.length ?? 0;
  }

  int getTotalAttendanceMarks(LectureModel lecture) {
    return lecture.attendancePerDay.values.fold<int>(
      0,
      (total, attendees) => total + attendees.length,
    );
  }

  double getAttendanceRate(LectureModel lecture) {
    final scheduledDays = lecture.daysOfWeek.length;
    final enrolledStudents = lecture.students.length;
    if (scheduledDays == 0 || enrolledStudents == 0) {
      return 0;
    }

    final possibleMarks = scheduledDays * enrolledStudents;
    final actualMarks = getTotalAttendanceMarks(lecture);
    return (actualMarks / possibleMarks).clamp(0, 1);
  }

  int getStudentAttendanceDays(LectureModel lecture, String studentId) {
    return lecture.attendancePerDay.values
        .where((attendees) => attendees.contains(studentId))
        .length;
  }

  int getScheduledDaysCount(LectureModel lecture) => lecture.daysOfWeek.length;
}
