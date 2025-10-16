class AnnouncementModel {
  final int id;
  final int facultyId;
  final String facultyName;
  final String title;
  final String description;
  final String date;
  final int batchId;
  final int? typeId;      // optional, can be null
  final String? typeName; // optional, can be null

  AnnouncementModel({
    required this.id,
    required this.facultyId,
    required this.facultyName,
    required this.title,
    required this.description,
    required this.date,
    required this.batchId,
    this.typeId,
    this.typeName,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['Announcement_id'] ?? 0,
      facultyId: json['faculty_id'] ?? 0,
      facultyName: json['faculty_name'] ?? '',
      title: json['Announcement_title'] ?? '',
      description: json['announcement_description'] ?? '',
      date: json['Announcement_date'] ?? '',
      batchId: json['batch_id'] ?? 0,
      typeId: json['Announcement_type_id'],
      typeName: json['Announcement_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Announcement_id': id,
      'faculty_id': facultyId,
      'faculty_name': facultyName,
      'Announcement_title': title,
      'announcement_description': description,
      'Announcement_date': date,
      'batch_id': batchId,
      'Announcement_type_id': typeId,
      'Announcement_type': typeName,
    };
  }
}