class RegSchedule {
  int subjectID;
  String subjectName;
  String shortName;
  String subjectCode;
  String subjectType;
  int sem;
  String eduType;
  int classID;
  String className;
  String batch;
  String classLocation;
  String lecType;
  String startTime;
  String endTime;

  RegSchedule({
    required this.subjectID,
    required this.subjectName,
    required this.sem,
    required this.shortName,
    required this.subjectCode,
    required this.subjectType,
    required this.eduType,
    required this.classID,
    required this.className,
    required this.batch,
    required this.classLocation,
    required this.lecType,
    required this.startTime,
    required this.endTime,
  });

  factory RegSchedule.fromJson(Map<String, dynamic> json) {
    return RegSchedule(
      subjectID: json['subjectID'] ?? 0,
      subjectName: json['subject_name'] ?? '',
      sem: json['sem'] ?? 0,
      shortName: json['short_name'] ?? '',
      subjectCode: json['subject_code'] ?? '',
      subjectType: json['type'][0].toUpperCase() + json['type'].substring(1) ?? '',
      eduType: json['edu_type'][0].toUpperCase() + json['edu_type'].substring(1) ?? '',
      classID: json['classID'] ??0,
      className: json['classname'] ?? '${json['short_name']}',
      batch: json['batch'] ?? 'ALL',
      classLocation: json['class_location'] ?? '',
      lecType: json['lec_type'],
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectID,
      'subject_name': subjectName,
      'short_name': shortName,
      'subject_code': subjectCode,
      'type': subjectType,
      'sem': sem,
      'edu_type': eduType,
      'class_id': classID,  // Handle null
      'classname': className,
      'batch': batch,
      'class_location': classLocation,
      'lec_type':lecType,
      'class_start_time': startTime,
      'class_end_time': endTime,
    };
  }
}
