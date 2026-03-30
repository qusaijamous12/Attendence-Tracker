import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/custom_text.dart';
import '../../auth/controller/login_controller.dart';
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
            onPressed: () => loginController.logOut(),
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.lecturesStatus.value == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final lectures = homeController.doctorLectures;
        if (lectures.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshLectures,
            child: const NoLecturesView(),
          );
        }

        final totalStudents = lectures.fold<int>(
          0,
          (sum, lecture) => sum + lecture.students.length,
        );
        final totalTodayAttendance = lectures.fold<int>(
          0,
          (sum, lecture) => sum + homeController.getTodayAttendanceCount(lecture),
        );
        final averageRate = lectures.isEmpty
            ? 0
            : (lectures
                        .map(homeController.getAttendanceRate)
                        .reduce((a, b) => a + b) /
                    lectures.length) *
                100;

        return RefreshIndicator(
          onRefresh: _refreshLectures,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Welcome back, ${loginController.userModel.value?.name ?? 'Doctor'}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track attendance, review lecture performance, and manage sections faster.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Lectures',
                      value: lectures.length.toString(),
                      color: AppColor.kPrimary,
                      icon: Icons.menu_book_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Enrolled',
                      value: totalStudents.toString(),
                      color: Colors.orange,
                      icon: Icons.groups_2_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Today',
                      value: totalTodayAttendance.toString(),
                      color: Colors.green,
                      icon: Icons.how_to_reg_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Average Rate',
                      value: '${averageRate.round()}%',
                      color: Colors.purple,
                      icon: Icons.insights_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...lectures.map((lecture) {
                final lectureDate = lecture.dateTime;
                final formattedTime =
                    '${lectureDate.hour.toString().padLeft(2, '0')}:${lectureDate.minute.toString().padLeft(2, '0')}';
                return LectureCell(
                  lecture: lecture,
                  formattedTime: formattedTime,
                );
              }),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const CreateLecture()),
        backgroundColor: AppColor.kPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Create Lecture',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
