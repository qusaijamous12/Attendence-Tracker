import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widget/custom_text.dart';
import '../../../add_students_screen.dart';
import '../../../generate_qr_code_screen.dart';
import '../../controller/home_controller.dart';
import '../../data/lecture_model.dart';

class LectureCell extends StatelessWidget {
  const LectureCell({
    super.key,
    required this.lecture,
    required this.formattedTime,
  });

  final LectureModel lecture;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>(tag: 'home_controller');
    final todayKey = DateTime.now().weekday.toString();
    final attendedToday = lecture.attendancePerDay[todayKey] ?? <String>[];
    final attendanceRate = (homeController.getAttendanceRate(lecture) * 100).round();
    final totalMarks = homeController.getTotalAttendanceMarks(lecture);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      title: '${lecture.students.length} students',
                      txtColor: AppColor.kPrimary,
                      fontWeight: AppFontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      title: '$attendanceRate% attendance',
                      fontSize: AppFontSize.f12,
                      txtColor: Colors.black54,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(
                label: 'Today',
                value: '${attendedToday.length} attended',
                color: Colors.green,
              ),
              _InfoChip(
                label: 'Recorded marks',
                value: '$totalMarks total',
                color: Colors.orange,
              ),
              _InfoChip(
                label: 'Schedule',
                value: lecture.daysOfWeek.join(', '),
                color: AppColor.kPrimary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => Get.to(() => AddStudentsScreen(lecture: lecture)),
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text(
                  'Add Students',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => GenerateQRCodeScreen(lecture: lecture)),
                icon: const Icon(Icons.qr_code, color: Colors.white),
                label: const Text(
                  'QR Code',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          attendedToday.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      title: 'Students attended today:',
                      fontSize: AppFontSize.f14,
                      fontWeight: AppFontWeight.bold,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: attendedToday
                          .map(
                            (studentId) => Chip(
                              label: Text(studentId),
                              backgroundColor: Colors.green.withValues(alpha: 0.1),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              : const CustomText(
                  title: 'No students attended today',
                  fontSize: AppFontSize.f14,
                  txtColor: Colors.grey,
                ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
