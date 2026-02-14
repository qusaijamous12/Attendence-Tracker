import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_color.dart';
import '../../../../core/config/app_styles.dart';
import '../../../../core/widget/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home/data/lecture_model.dart';

class AddStudentsScreen extends StatefulWidget {
  final LectureModel lecture;

  const AddStudentsScreen({super.key, required this.lecture});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> allStudents = [];
  List<Map<String, dynamic>> filteredStudents = [];
  Set<String> addedStudentIds = {};

  @override
  void initState() {
    super.initState();
    _fetchStudents();
    _loadAddedStudents();
  }

  void _loadAddedStudents() {
    addedStudentIds = widget.lecture.students.toSet();
  }

  Future<void> _fetchStudents() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .get();

    final students = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'fullName': data['fullName'] ?? '',
        'email': data['email'] ?? '',
      };
    }).toList();

    setState(() {
      allStudents = students;
      filteredStudents = students;
    });
  }

  void _searchStudent(String query) {
    final filtered = allStudents
        .where((s) => s['fullName'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredStudents = filtered;
    });
  }

  Future<void> _addStudent(String studentId) async {
    if (addedStudentIds.contains(studentId)) {
      Get.snackbar(
        'Info',
        'Student is already added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final lectureRef = _firestore.collection('lectures').doc(widget.lecture.id);
    final lectureSnap = await lectureRef.get();
    final studentsList = List<String>.from(lectureSnap['students'] ?? []);

    if (!studentsList.contains(studentId)) {
      studentsList.add(studentId);
      await lectureRef.update({'students': studentsList});

      Get.snackbar(
        'Success',
        'Student added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.kPrimary,
        colorText: Colors.white,
      );

      setState(() {
        addedStudentIds.add(studentId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.kPrimary,
        title: const CustomText(
          title: 'Add Students',
          fontSize: AppFontSize.f20,
          fontWeight: AppFontWeight.bold,
          txtColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: _searchStudent,
              decoration: InputDecoration(
                hintText: 'Search students',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Students List
            Expanded(
              child: filteredStudents.isEmpty
                  ? const Center(
                child: CustomText(
                  title: 'No students found',
                  fontSize: AppFontSize.f16,
                  txtColor: Colors.grey,
                ),
              )
                  : ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  final isAdded = addedStudentIds.contains(student['id']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: student['fullName'],
                              fontWeight: AppFontWeight.bold,
                            ),
                            CustomText(
                              title: student['email'],
                              txtColor: Colors.grey,
                              fontSize: AppFontSize.f14,
                            ),
                          ],
                        ),
                        isAdded
                            ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const CustomText(
                            title: 'Added',
                            txtColor: Colors.green,
                            fontWeight: AppFontWeight.bold,
                          ),
                        )
                            : ElevatedButton(
                          onPressed: () => _addStudent(student['id']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

