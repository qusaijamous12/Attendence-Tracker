import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/config/app_color.dart';
import '../core/config/app_styles.dart';
import '../core/widget/ components/my_btn.dart';
import '../core/widget/ components/my_txt_field.dart';
import '../core/widget/custom_text.dart';
import 'auth/controller/login_controller.dart';
import 'home/controller/home_controller.dart';

class CreateLecture extends StatefulWidget {
  const CreateLecture({super.key});

  @override
  State<CreateLecture> createState() => _CreateLectureState();
}

class _CreateLectureState extends State<CreateLecture> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _sectionController = TextEditingController();
  final _roomController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final homeController = Get.find<HomeController>(tag: 'home_controller');

  final Map<int, String> weekDays = const {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };
  final List<int> _selectedDays = [];

  @override
  void dispose() {
    _titleController.dispose();
    _courseCodeController.dispose();
    _sectionController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _createLecture() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      Get.snackbar(
        'Error',
        'Please select date and time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one day of the week',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      return;
    }

    final lectureDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    await homeController.createLecture(
      title: _titleController.text,
      courseCode: _courseCodeController.text,
      section: _sectionController.text,
      room: _roomController.text,
      dateTime: lectureDateTime,
      daysOfWeek: _selectedDays.map((e) => e.toString()).toList(),
    );

    if (homeController.createLectureStatus.value == RequestStatus.success &&
        mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const CustomText(
          title: 'Create Lecture',
          fontSize: AppFontSize.f20,
          fontWeight: AppFontWeight.bold,
          txtColor: Colors.white,
        ),
        backgroundColor: AppColor.kPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTxtField(
                title: 'Lecture Title',
                hintText: 'Enter lecture title',
                controller: _titleController,
                prefixIcon: const Icon(Icons.book),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              MyTxtField(
                title: 'Course Code',
                hintText: 'Example: BIO101',
                controller: _courseCodeController,
                prefixIcon: const Icon(Icons.badge_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Course code cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MyTxtField(
                      title: 'Section',
                      hintText: 'A1',
                      controller: _sectionController,
                      prefixIcon: const Icon(Icons.group_work_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Section is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyTxtField(
                      title: 'Room',
                      hintText: 'Hall 204',
                      controller: _roomController,
                      prefixIcon: const Icon(Icons.meeting_room_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Room is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickDate,
                child: _PickerTile(
                  title: _selectedDate == null
                      ? 'Select Date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickTime,
                child: _PickerTile(
                  title: _selectedTime == null
                      ? 'Select Time'
                      : _selectedTime!.format(context),
                  icon: Icons.access_time,
                ),
              ),
              const SizedBox(height: 28),
              const CustomText(
                title: 'Select Lecture Days',
                fontSize: AppFontSize.f16,
                fontWeight: AppFontWeight.bold,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: weekDays.entries.map((entry) {
                  final dayIndex = entry.key;
                  final isSelected = _selectedDays.contains(dayIndex);

                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (!_selectedDays.contains(dayIndex)) {
                            _selectedDays.add(dayIndex);
                          }
                        } else {
                          _selectedDays.remove(dayIndex);
                        }
                      });
                    },
                    selectedColor: AppColor.kPrimary,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const CustomText(
                  title:
                      'New idea added: each lecture now stores course code, section, and room so doctors, students, and admin can filter and understand the schedule faster.',
                  fontSize: AppFontSize.f14,
                  txtColor: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Obx(() {
                if (homeController.createLectureStatus.value ==
                    RequestStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return MyBtn(title: 'Create Lecture', onPressed: _createLecture);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(title: title),
          Icon(icon),
        ],
      ),
    );
  }
}
