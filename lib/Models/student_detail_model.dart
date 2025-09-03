class StudentDetailsModel {
  int studentId;
  String studentName;
  String enrollmentNo;
  String grNo;
  String studentEmail;
  String studentPhone;
  String classname;
  String classbatch;
  String birthdate;
  String gender;
  String address;
  int sem;
  String eduType;
  String parentName;
  String profession;
  String parentPhone;
  int batchId;
  String batchStartYear;
  String batchEndYear;
  String placementSupport;

  StudentDetailsModel({
    required this.studentId,
    required this.studentName,
    required this.enrollmentNo,
    required this.grNo,
    required this.studentEmail,
    required this.studentPhone,
    required this.classname,
    required this.classbatch,
    required this.birthdate,
    required this.gender,
    required this.address,
    required this.sem,
    required this.eduType,
    required this.parentName,
    required this.profession,
    required this.parentPhone,
    required this.batchId,
    required this.batchStartYear,
    required this.batchEndYear,
    required this.placementSupport,
  });

  factory StudentDetailsModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailsModel(
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'] ?? "",
      enrollmentNo: json['enrollment_no'] ?? "",
      grNo: json['gr_no'] ?? "",
      studentEmail: json['student_email'] ?? "",
      studentPhone: json['student_phone'] ?? "",
      classname: json['classname'] ?? "",
      classbatch: json['classbatch'] ?? "",
      birthdate: json['birth_date'] ?? "",
      gender: json['gender'] ?? "",
      address: json['address'] ?? "",
      sem: json['sem'] ?? 0,
      eduType: json['edu_type'] ?? "",
      parentName: json['parent_name'] ?? "",
      profession: json['profession'] ?? "",
      parentPhone: json['parent_phone'] ?? "",
      batchId: json['batch_id'] ?? 0,
      batchStartYear: json['batch_start_year'] ?? "",
      batchEndYear: json['batch_end_year'] ?? "",
      placementSupport: json['placement_support'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'enrollment_no': enrollmentNo,
      'gr_no': grNo,
      'student_email': studentEmail,
      'student_phone': studentPhone,
      'classname': classname,
      'classbatch': classbatch,
      'birth_date': birthdate,
      'gender': gender,
      'address': address,
      'sem': sem,
      'edu_type': eduType,
      'parent_name': parentName,
      'profession': profession,
      'parent_phone': parentPhone,
      'batch_id': batchId,
      'batch_start_year': batchStartYear,
      'batch_end_year': batchEndYear,
      'placement_support': placementSupport,
    };
  }
}