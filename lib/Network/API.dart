// ngrok URL (changes every restart)
const String host = "https://212d2dcc592c.ngrok-free.app";

// adjust path (since your index.php is at root of ict-server-main)
const String serverPath = "/ict-server-testing/api/index.php";

String validateLogoutAPI = "$host$serverPath/Faculty/logout";

String CurrentVersion = "1.0";
String validApiKey = "ictmu";
String updateURL = 'https://devanpatel28.blogspot.com/';

const String validateLoginAPI = "$host$serverPath/Faculty/login";

String validateVersionAPI = '$host$serverPath/AppVersion/check';

String updatePasswordAPI = '$host$serverPath/Password/updatePassword';

String getScheduleAPI = '$host$serverPath/Attendance/GetFacultySchedule';
String getAttendanceListAPI = '$host$serverPath/Attendance/GetAttendanceList';
String uploadAttendanceAPI = '$host$serverPath/Attendance/UploadAttendance';
String getStudentByCCAPI = '$host$serverPath/Attendance/GetStudentsByCC';
String getEngagedStudentByCCAPI =
    '$host$serverPath/Attendance/GetEngagedStudentsByCC';
String upsertEngagedStudentAPI =
    '$host$serverPath/Attendance/UpsertEngagedStudent';
String getExtraScheduleAPI = '$host$serverPath/Attendance/GetExtraSchedule';
String getExtraAttendanceListAPI =
    '$host$serverPath/Attendance/GetExtraAttendanceList';
String uploadExtraAttendanceAPI =
    '$host$serverPath/Attendance/UploadExtraAttendance';

String facultyPunch = '$host$serverPath/Attendance/facultyAttendance';
String totalAttendanceAPI = '$host$serverPath/Attendance/TotalAttendance';
String attendanceByDateAPI = '$host$serverPath/Attendance/AttendanceByDate';

String recentlyPlacedAPI = '$host$serverPath/Placement/recentlyPlaced';
String campusDriveStudentRoundsAPI =
    '$host$serverPath/Placement/campusDriveStudentRoundList';

String feedbackHistoryAPI = '$host$serverPath/Feedback/by-faculty';
String feedbackStatusUpdateAPI = '$host$serverPath/Feedback/update-viewed';

String studentDetailsAPI = '$host$serverPath/Student/by-enrolment';

String studentImageAPI(gr) {
  String api =
      "https://student.marwadiuniversity.ac.in:553/handler/getImage.ashx?SID=$gr";
  return api;
}

String facultyImageAPI(fId) {
  String api =
      "https://marwadieducation.edu.in/MEFOnline/handler/getImage.ashx?Id=$fId";
  return api;
}
