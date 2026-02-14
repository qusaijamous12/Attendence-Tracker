import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/custom_text.dart';
import '../../auth/controller/login_controller.dart';
import '../../auth/views/login_view.dart';
import '../../create_lecture.dart';

import '../controller/home_controller.dart';
import 'widgets/lecture_cell.dart';
import 'widgets/no_lectures_view.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final homeController = Get.find<HomeController>(tag: 'home_controller');
  final loginController = Get.find<LoginController>(tag: 'login_controller');

  @override
  void initState() {
    super.initState();
    homeController.getDoctorLectures();
  }

  Future<void> _refreshLectures() async {
    await homeController.getDoctorLectures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColor.kPrimary,
        elevation: 0,
        title: const CustomText(
          title: 'Doctor Dashboard',
          fontSize: AppFontSize.f20,
          fontWeight: AppFontWeight.bold,
          txtColor: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: ()=>loginController.logOut(),
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Obx(
            () {
          if (homeController.lecturesStatus.value == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final lectures = homeController.doctorLectures;
          if (lectures.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshLectures,
              child:const NoLecturesView(),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshLectures,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lectures.length,
              itemBuilder: (context, index) {
                final lecture = lectures[index];
                final lectureDate = lecture.dateTime;
                final formattedTime =
                    '${lectureDate.hour.toString().padLeft(2, '0')}:${lectureDate.minute.toString().padLeft(2, '0')}';
                return LectureCell(lecture: lecture, formattedTime: formattedTime);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateLecture()),
        backgroundColor: AppColor.kPrimary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
