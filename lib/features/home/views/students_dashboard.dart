import 'package:flutter/material.dart';
import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../auth/controller/login_controller.dart';
import '../../auth/views/login_view.dart';
import '../../qr_scanner_screen.dart';
import '../controller/home_controller.dart';


class StudentsDashboard extends StatefulWidget {
  const StudentsDashboard({super.key});

  @override
  State<StudentsDashboard> createState() => _StudentsDashboardState();
}

class _StudentsDashboardState extends State<StudentsDashboard> {
  final homeController = Get.put(HomeController());
  final loginController = Get.find<LoginController>(tag: 'login_controller');

  @override
  void initState() {
    super.initState();
    homeController.getStudentLectures();
  }

  Future<void> _refreshLectures() async {
    await homeController.getStudentLectures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColor.kPrimary,
        elevation: 0,
        title: const CustomText(
          title: 'Welcome, Student!',
          fontSize: AppFontSize.f20,
          fontWeight: AppFontWeight.bold,
          txtColor: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () => loginController.logOut(),
            icon: const Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),
      body: Obx(() {
        if (homeController.lecturesStatus.value == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final lectures = homeController.studentLectures;
        final student = loginController.userModel.value;

        return RefreshIndicator(
          onRefresh: _refreshLectures,
          child: lectures.isEmpty
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Icon(Icons.menu_book, size: 80, color: AppColor.kPrimary.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              const CustomText(
                title: 'No lectures yet',
                fontSize: AppFontSize.f18,
                txtColor: Colors.grey,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText(
                  title: 'Your lectures will appear here once added by your doctor.',
                  fontSize: AppFontSize.f14,
                  txtColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lectures.length,
            itemBuilder: (context, index) {
              final lecture = lectures[index];

              final formattedTime =
                  "${lecture.dateTime.hour.toString().padLeft(2, '0')}:${lecture.dateTime.minute.toString().padLeft(2, '0')}";

              final todayKey = DateTime.now().weekday.toString(); // "1".."7"

              final isAttended = student != null &&
                  lecture.attendancePerDay.containsKey(todayKey) &&
                  lecture.attendancePerDay[todayKey]!.contains(student.id);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Lecture info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: lecture.title,
                          fontSize: AppFontSize.f16,
                          fontWeight: AppFontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          title: formattedTime,
                          fontSize: AppFontSize.f14,
                          txtColor: Colors.grey,
                        ),
                      ],
                    ),
                    // Attendance status + Scan
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isAttended ? Colors.green.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomText(
                            title: isAttended ? 'Attended' : 'Pending',
                            txtColor: isAttended ? Colors.green : Colors.orange,
                            fontWeight: AppFontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: isAttended
                              ? null
                              : () => Get.to(() => QRScannerScreen(lectureId: lecture.id)),
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                          label: Text(isAttended ? 'Attended' : 'Scan', style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAttended ? Colors.grey : AppColor.kPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),

    );
  }
}


