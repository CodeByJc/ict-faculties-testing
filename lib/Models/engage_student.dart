class EngagedStudent {
  int? id;
  int? studentInfoId;
  String? reason;
  String? type;
  int? facultyInfoId;
  DateTime? startDate;
  DateTime? endDate;
  String? studentName;
  String? enrollmentNo;
  String? facultyName;

  EngagedStudent({
    this.id,
    this.studentInfoId,
    this.reason,
    this.type,
    this.facultyInfoId,
    this.startDate,
    this.endDate,
    this.studentName,
    this.enrollmentNo,
    this.facultyName,
  });

  // Factory method to create an EngagedStudent instance from a JSON map
  factory EngagedStudent.fromJson(Map<String, dynamic> json) {
    return EngagedStudent(
      id: json['id'] as int?,
      studentInfoId: json['student_info_id'] as int?,
      reason: json['reason'] as String?,
      type: json['type'] as String?,
      facultyInfoId: json['faculty_info_id'] as int?,
      startDate: DateTime.tryParse(json['start_date'] ?? ''),
      endDate: DateTime.tryParse(json['end_date'] ?? ''),
      studentName: json['student_name'] as String?,
      enrollmentNo: json['enrollment_no'] as String?,
      facultyName: json['faculty_name'] as String?,
    );
  }

  // Method to convert EngagedStudent instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_info_id': studentInfoId,
      'reason': reason,
      'type': type,
      'faculty_info_id': facultyInfoId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'student_name': studentName,
      'enrollment_no': enrollmentNo,
      'faculty_name': facultyName,
    };
  }
}
