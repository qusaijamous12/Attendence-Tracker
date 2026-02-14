import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widget/custom_text.dart';
import '../../../add_students_screen.dart';
import '../../../generate_qr_code_screen.dart';
import '../../data/lecture_model.dart';


class LectureCell extends StatelessWidget {
  final LectureModel lecture;
  final String formattedTime;

  const LectureCell({
    super.key,
    required this.lecture,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final todayKey = DateTime.now().weekday.toString();

    final attendedToday = lecture.attendancePerDay.containsKey(todayKey)
        ? lecture.attendancePerDay[todayKey]!
        : <String>[];
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText(
                  title: '${lecture.students.length} students',
                  txtColor: AppColor.kPrimary,
                  fontWeight: AppFontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Buttons row
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

          // Attendance list for today
          attendedToday.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const CustomText(
                title: 'Students Attended Today:',
                fontSize: AppFontSize.f14,
                fontWeight: AppFontWeight.bold,
              ),
              const SizedBox(height: 4),
              ...attendedToday.map(
                    (studentId) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: CustomText(
                    title: studentId,
                    fontSize: AppFontSize.f14,
                  ),
                ),
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

