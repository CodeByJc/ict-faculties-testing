class ExtraMarkAttendanceData {
  final int? subjectId;
  final int? facultyId;
  final int? studentId;
  final String? date;
  final int? count;


  ExtraMarkAttendanceData({
    required this.subjectId,
    required this.facultyId,
    required this.studentId,
    required this.date,
    required this.count,
  });

  // Method to convert instance to JSON format for Network
  Map<String, dynamic> toJson() {
    return {
      'subject_info_id': subjectId,
      'faculty_info_id': facultyId,
      'student_info_id': studentId,
      'date': date,
      'count': count,
    };
  }
}
