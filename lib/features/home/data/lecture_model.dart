import 'package:cloud_firestore/cloud_firestore.dart';

class LectureModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final List<String> students;
  final Map<String, List<String>> attendancePerDay; // <-- حضور لكل يوم
  final List<String> daysOfWeek; // <-- أيام المحاضرة
  final String qrHash;

  LectureModel({
    required this.id,
    required this.title,
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
      dateTime: (json['dateTime'] as dynamic) is Timestamp
          ? (json['dateTime'] as Timestamp).toDate()
          : DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      students: List<String>.from(json['students'] ?? []),
      attendancePerDay: Map<String, List<String>>.from(
          (json['attendancePerDay'] ?? {}).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
          )),
      daysOfWeek: List<String>.from(json['daysOfWeek'] ?? []),
      qrHash: json['qrHash'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime,
      'students': students,
      'attendancePerDay': attendancePerDay,
      'daysOfWeek': daysOfWeek,
      'qrHash': qrHash,
      'id': id,
    };
  }
}
