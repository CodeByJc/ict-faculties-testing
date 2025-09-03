class Student {
  int? id;
  String? enrollmentNo;
  String? grNo;
  int? classInfoId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNo;
  int? isActive;
  int? addressInfoId;
  String? gender;
  String? birthDate;
  int? parentInfoId;
  int? mentorId;
  String? batchStartYear;
  String? batchEndYear;
  int? sem;
  String? eduType;

  Student({
    this.id,
    this.enrollmentNo,
    this.grNo,
    this.classInfoId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNo,
    this.isActive,
    this.addressInfoId,
    this.gender,
    this.birthDate,
    this.parentInfoId,
    this.mentorId,
    this.batchStartYear,
    this.batchEndYear,
    this.sem,
    this.eduType,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int?,
      enrollmentNo: json['enrollment_no'] as String?,
      grNo: json['gr_no'] as String?,
      classInfoId: json['class_info_id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNo: json['phone_no'] as String?,
      isActive: json['isactive'] as int?,
      addressInfoId: json['address_info_id'] as int?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] as String?,
      parentInfoId: json['parent_info_id'] as int?,
      mentorId: json['mentor_id'] as int?,
      batchStartYear: json['batch_start_year'] as String?,
      batchEndYear: json['batch_end_year'] as String?,
      sem: json['sem'] as int?,
      eduType: json['edu_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enrollment_no': enrollmentNo,
      'gr_no': grNo,
      'class_info_id': classInfoId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_no': phoneNo,
      'isactive': isActive,
      'address_info_id': addressInfoId,
      'gender': gender,
      'birth_date': birthDate,
      'parent_info_id': parentInfoId,
      'mentor_id': mentorId,
      'batch_start_year': batchStartYear,
      'batch_end_year': batchEndYear,
      'sem': sem,
      'edu_type': eduType,
    };
  }
}
