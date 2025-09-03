class Faculty {
  String? email;
  String? phoneNo;
  int? id;
  String? userLoginId;
  String? facultyId;
  String? firstName;
  String? lastName;
  int? addressInfoId;
  String? gender;
  String? profilePic;
  DateTime? birthDate;
  String? designation;
  String joiningDate;

  Faculty({
    this.email,
    this.phoneNo,
    this.id,
    this.userLoginId,
    this.facultyId,
    this.firstName,
    this.lastName,
    this.addressInfoId,
    this.gender,
    this.profilePic,
    this.birthDate,
    this.designation,
    required this.joiningDate,
  });

  // Factory method to create a User instance from a JSON map
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      email: json['email']?.toString(),
      phoneNo: json['phone_no']?.toString(),
      id: json['id'],
      userLoginId: json['user_login_id']?.toString(),
      facultyId: json['faculty_id']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      addressInfoId: json['address_info_id'],
      gender: json['gender']?.toString(),
      profilePic: json['profile_pic']?.toString(),
      birthDate: DateTime.tryParse(json['birth_date']!=null?json['birth_date'].toString():''),
      designation: json['designation']?.toString(),
      joiningDate: json['joining_date']??"",
    );
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone_no': phoneNo,
      'id': id,
      'user_login_id': userLoginId,
      'faculty_id': facultyId,
      'first_name': firstName,
      'last_name': lastName,
      'address_info_id': addressInfoId,
      'gender': gender,
      'profile_pic': profilePic,
      'birth_date': birthDate?.toIso8601String(),
      'designation': designation,
      'joining_date': joiningDate,
    };
  }
}
