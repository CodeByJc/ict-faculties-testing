class PunchModel {
  final int? id;
  final String? punchIn;
  final String? punchOut;
  final String? date;
  final int? facultyInfoId;
  final bool status;
  final String message;

  PunchModel({
    this.id,
    this.punchIn,
    this.punchOut,
    this.date,
    this.facultyInfoId,
    required this.status,
    required this.message,
  });

  factory PunchModel.fromJson(Map<String, dynamic> json) {
    return PunchModel(
      id: json['id'],
      punchIn: json['punch_in'],
      punchOut: json['punch_out'],
      date: json['date'],
      facultyInfoId: json['faculty_info_id'],
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'punch_in': punchIn,
      'punch_out': punchOut,
      'date': date,
      'faculty_info_id': facultyInfoId,
      'status': status,
      'message': message,
    };
  }
}