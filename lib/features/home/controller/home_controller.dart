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
    required DateTime dateTime,
    required List<String> daysOfWeek, // أيام المحاضرة الجديدة
  })
  async {
    createLectureStatus.value = RequestStatus.loading;

    try {
      final doctor = loginController.userModel.value;
      if (doctor == null) {
        createLectureStatus.value = RequestStatus.error;
        Get.snackbar('Error', 'Doctor not logged in', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final docRef = _firebaseInstance.collection('lectures').doc();
      final qrHash = '${docRef.id}-${DateTime.now().millisecondsSinceEpoch}';

      // attendancePerDay فارغ لكل يوم محدد
      Map<String, List<String>> attendance = {};
      for (var day in daysOfWeek) {
        attendance[day] = [];
      }

      await docRef.set({
        'title': title,
        'doctorId': doctor.id,
        'dateTime': dateTime,
        'students': [],
        'attendancePerDay': attendance,
        'daysOfWeek': daysOfWeek,
        'qrHash': qrHash,
      });

      createLectureStatus.value = RequestStatus.success;
      Get.snackbar('Success', 'Lecture created successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.blue, colorText: Colors.white);

      await getDoctorLectures();
    } catch (e) {
      createLectureStatus.value = RequestStatus.error;
      Get.snackbar('Error', 'Failed to create lecture', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
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

      final lecturesList = querySnapshot.docs.map((doc) {
        final data = doc.data();

        return LectureModel(
          id: doc.id,
          title: data['title'] ?? '',
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          students: List<String>.from(data['students'] ?? []),
          attendancePerDay: Map<String, List<String>>.from(
            (data['attendancePerDay'] ?? {}).map(
                  (k, v) => MapEntry(k, List<String>.from(v)),
            ),
          ),
          qrHash: data['qrHash'] ?? '',
          daysOfWeek: List<String>.from(data['daysOfWeek'] ?? []),
        );
      }).toList();

      doctorLectures.assignAll(lecturesList);
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
      print('error is ${e.toString()}');
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

      final lecturesList = querySnapshot.docs.map((doc) {
        final data = doc.data();

        return LectureModel(
          id: doc.id,
          title: data['title'] ?? '',
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          students: List<String>.from(data['students'] ?? []),
          attendancePerDay: Map<String, List<String>>.from(
            (data['attendancePerDay'] ?? {}).map(
                  (k, v) => MapEntry(k, List<String>.from(v)),
            ),
          ),
          qrHash: data['qrHash'] ?? '',
          daysOfWeek: List<String>.from(data['daysOfWeek'] ?? []),
        );
      }).toList();

      studentLectures.assignAll(lecturesList);
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
      print('error is ${e.toString()}');
    }
  }
}




