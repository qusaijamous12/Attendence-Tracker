import 'package:cloud_firestore/cloud_firestore.dart';

class LectureModel {
  final String id;
  final String title;
  final String courseCode;
  final String section;
  final String room;
  final DateTime dateTime;
  final List<String> students;
  final Map<String, List<String>> attendancePerDay;
  final List<String> daysOfWeek;
  final String qrHash;

  LectureModel({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.section,
    required this.room,
    required this.dateTime,
    required this.students,
    required this.attendancePerDay,
    required this.daysOfWeek,
    required this.qrHash,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json, String docId) {
    return LectureModel(
      id: docId,
      title: json['title'] ?? '',
      courseCode: json['courseCode'] ?? '',
      section: json['section'] ?? '',
      room: json['room'] ?? '',
      dateTime: (json['dateTime'] as dynamic) is Timestamp
          ? (json['dateTime'] as Timestamp).toDate()
          : DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      students: List<String>.from(json['students'] ?? []),
      attendancePerDay: Map<String, List<String>>.from(
        (json['attendancePerDay'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
      daysOfWeek: List<String>.from(json['daysOfWeek'] ?? []),
      qrHash: json['qrHash'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'courseCode': courseCode,
      'section': section,
      'room': room,
      'dateTime': dateTime,
      'students': students,
      'attendancePerDay': attendancePerDay,
      'daysOfWeek': daysOfWeek,
      'qrHash': qrHash,
      'id': id,
    };
  }
}
