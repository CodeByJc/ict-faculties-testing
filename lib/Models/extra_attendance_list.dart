class ExtraAttendanceList {
  int? studentID;
  String? enrollment;
  String? studentGR;
  String? studentName;
  String? classname;
  String? classBatch;
  int? count;

  ExtraAttendanceList(
      {required this.studentID,
      required this.enrollment,
      required this.studentName,
      required this.studentGR,
      required this.classname,
      required this.classBatch,
      required this.count});
  @override
  String toString() {
    return 'Enroll: $enrollment, GR: $studentGR, Name: $studentName, Class: $classname, Batch: $classBatch, count: $count';
  }

  factory ExtraAttendanceList.fromJson(Map<String, dynamic> json) {
    return ExtraAttendanceList(
        studentID: json['studentId'] as int?,
        enrollment: json['enrollment_no'] as String?,
        studentGR: json['gr_no'] as String?,
        studentName: json['student_name'] as String?,
        classname: json['classname'] as String?,
        classBatch: json['class_batch'] as String?,
        count: json['count'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentID,
      'enrollment_no': enrollment,
      'student_gr': studentGR,
      'student_name': studentName,
      'classname': classname,
      'batch': classBatch,
      'count': count
    };
  }

  ExtraAttendanceList copyWith({int? newCount}) {
    return ExtraAttendanceList(
      studentID: studentID,
      enrollment: enrollment,
      studentGR: studentGR,
      studentName: studentName,
      classname: classname,
      classBatch: classBatch,
      count: newCount ?? count,
    );
  }
}
