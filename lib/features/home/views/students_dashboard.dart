import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/custom_text.dart';
import '../../auth/controller/login_controller.dart';
import '../../qr_scanner_screen.dart';
import '../controller/home_controller.dart';

class StudentsDashboard extends StatefulWidget {
  const StudentsDashboard({super.key});

  @override
  State<StudentsDashboard> createState() => _StudentsDashboardState();
}

class _StudentsDashboardState extends State<StudentsDashboard> {
  final homeController = Get.find<HomeController>(tag: 'home_controller');
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
          title: 'Student Dashboard',
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

        final lectures = homeController.studentLectures;
        final student = loginController.userModel.value;
        final studentId = student?.id ?? '';
        final totalAttendedDays = lectures.fold<int>(
          0,
          (sum, lecture) => sum + homeController.getStudentAttendanceDays(lecture, studentId),
        );
        final totalScheduledDays = lectures.fold<int>(
          0,
          (sum, lecture) => sum + homeController.getScheduledDaysCount(lecture),
        );
        final attendanceRate = totalScheduledDays == 0
            ? 0
            : ((totalAttendedDays / totalScheduledDays) * 100).round();

        return RefreshIndicator(
          onRefresh: _refreshLectures,
          child: lectures.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.24),
                    Icon(
                      Icons.menu_book,
                      size: 80,
                      color: AppColor.kPrimary.withValues(alpha: 0.4),
                    ),
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
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Welcome, ${student?.name ?? 'Student'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your dashboard now includes attendance history and schedule details for each lecture.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _StudentStatCard(
                            title: 'Lectures',
                            value: lectures.length.toString(),
                            icon: Icons.menu_book_rounded,
                            color: AppColor.kPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StudentStatCard(
                            title: 'Attended Days',
                            value: totalAttendedDays.toString(),
                            icon: Icons.how_to_reg_rounded,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _StudentStatCard(
                      title: 'Overall Attendance Rate',
                      value: '$attendanceRate%',
                      icon: Icons.insights_rounded,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 20),
                    ...lectures.map((lecture) {
                      final formattedTime =
                          '${lecture.dateTime.hour.toString().padLeft(2, '0')}:${lecture.dateTime.minute.toString().padLeft(2, '0')}';

                      final todayKey = DateTime.now().weekday.toString();
                      final isAttended = student != null &&
                          lecture.attendancePerDay.containsKey(todayKey) &&
                          lecture.attendancePerDay[todayKey]!.contains(student.id);
                      final attendedDays =
                          homeController.getStudentAttendanceDays(lecture, studentId);
                      final scheduledDays =
                          homeController.getScheduledDaysCount(lecture);

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
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        title: lecture.title,
                                        fontSize: AppFontSize.f16,
                                        fontWeight: AppFontWeight.bold,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        title:
                                            '${lecture.courseCode} - Section ${lecture.section} - Room ${lecture.room}',
                                        fontSize: AppFontSize.f12,
                                        txtColor: Colors.grey.shade700,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        title: formattedTime,
                                        fontSize: AppFontSize.f14,
                                        txtColor: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAttended
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CustomText(
                                    title: isAttended ? 'Attended' : 'Pending',
                                    txtColor:
                                        isAttended ? Colors.green : Colors.orange,
                                    fontWeight: AppFontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _HistoryChip(
                                  title: 'History',
                                  value: '$attendedDays / $scheduledDays days',
                                  color: AppColor.kPrimary,
                                ),
                                _HistoryChip(
                                  title: 'Days',
                                  value: lecture.daysOfWeek.join(', '),
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: isAttended
                                    ? null
                                    : () => Get.to(
                                          () => QRScannerScreen(lectureId: lecture.id),
                                        ),
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  isAttended ? 'Attended' : 'Scan Attendance',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isAttended ? Colors.grey : AppColor.kPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
        );
      }),
    );
  }
}

class _StudentStatCard extends StatelessWidget {
  const _StudentStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

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
          Text(title, style: const TextStyle(color: Colors.grey)),
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

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
