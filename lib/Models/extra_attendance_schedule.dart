class ExtraSchedule {
  int subjectID;
  String subjectName;
  String shortName;
  String subjectCode;
  String subjectType;
  String lecType;
  String eduType;
  int semId;
  int sem;

  ExtraSchedule({
    required this.subjectID,
    required this.subjectName,
    required this.semId,
    required this.shortName,
    required this.subjectCode,
    required this.subjectType,
    required this.lecType,
    required this.eduType,
    required this.sem
  });

  factory ExtraSchedule.fromJson(Map<String, dynamic> json) {
    return ExtraSchedule(
      subjectID: json['id'] ?? 0,
      subjectName: json['subject_name'] ?? '',
      semId: json['sem_info_id'] ?? 0,
      shortName: json['short_name'] ?? '',
      subjectCode: json['subject_code'] ?? '',
      subjectType: json['type'][0].toUpperCase() + json['type'].substring(1) ?? '',
      eduType: json['edu_type'][0].toUpperCase() + json['edu_type'].substring(1) ?? '',
      lecType: json['lec_type']??'',
      sem: json['sem']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectID,
      'subject_name': subjectName,
      'short_name': shortName,
      'subject_code': subjectCode,
      'type': subjectType,
      'sem_info_id': semId,
      'lec_type': lecType,
      'edu_type': eduType,
      'sem':sem,
    };
  }
}
