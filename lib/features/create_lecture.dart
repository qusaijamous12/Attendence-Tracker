import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/ components/my_btn.dart';
import '../../../core/widget/ components/my_txt_field.dart';
import '../../../core/widget/custom_text.dart';
import 'auth/controller/login_controller.dart';
import 'home/controller/home_controller.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_color.dart';
import '../../../core/config/app_styles.dart';
import '../../../core/widget/ components/my_btn.dart';
import '../../../core/widget/ components/my_txt_field.dart';
import '../../../core/widget/custom_text.dart';
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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final homeController = Get.find<HomeController>(tag: 'home_controller');

  // Days selection
  final Map<int, String> weekDays = {
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
    super.dispose();
  }

  // Pick starting date (first lecture date)
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Pick lecture time
  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Create lecture
  Future<void> _createLecture() async {
    if (!_formKey.currentState!.validate()) return;

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
      dateTime: lectureDateTime,
      daysOfWeek: _selectedDays.map((e) => e.toString()).toList(),
    );

    if (homeController.createLectureStatus.value == RequestStatus.success) {
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
              // Lecture title
              MyTxtField(
                title: 'Lecture Title',
                hintText: 'Enter lecture title',
                controller: _titleController,
                prefixIcon: const Icon(Icons.book),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Title cannot be empty';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pick Date
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      const Icon(Icons.calendar_today)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pick Time
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: _selectedTime == null
                            ? 'Select Time'
                            : _selectedTime!.format(context),
                      ),
                      const Icon(Icons.access_time)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Select Days of the week
              CustomText(
                title: 'Select Lecture Days:',
                fontSize: AppFontSize.f16,
                fontWeight: AppFontWeight.bold,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: weekDays.entries.map((entry) {
                  final dayIndex = entry.key;
                  final dayName = entry.value;
                  final isSelected = _selectedDays.contains(dayIndex);

                  return ChoiceChip(
                    label: Text(dayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (!_selectedDays.contains(dayIndex)) _selectedDays.add(dayIndex);
                        } else {
                          _selectedDays.remove(dayIndex);
                        }
                      });
                    },
                    selectedColor: AppColor.kPrimary,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Create button
              Obx(() {
                if (homeController.createLectureStatus.value == RequestStatus.loading) {
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

