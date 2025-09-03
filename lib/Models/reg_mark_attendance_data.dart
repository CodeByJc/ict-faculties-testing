class RegMarkAttendanceData {
  final int? subjectId;
  final int? facultyId;
  final int? studentId;
  final String? date;
  final String? status;
  final String? classStartTime;
  final String? classEndTime;
  final String? lecType;

  RegMarkAttendanceData({
    required this.subjectId,
    required this.facultyId,
    required this.studentId,
    required this.date,
    required this.status,
    required this.classStartTime,
    required this.classEndTime,
    required this.lecType,
  });

  // Method to convert instance to JSON format for Network
  Map<String, dynamic> toJson() {
    return {
      'subject_info_id': subjectId,
      'faculty_info_id': facultyId,
      'student_info_id': studentId,
      'date': date,
      'status': status,
      'class_start_time': classStartTime,
      'class_end_time': classEndTime,
      'lec_type': lecType,
    };
  }
}
