import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Helper/Utils.dart';
import 'package:intl/intl.dart';
import '../Models/reg_attendance_list.dart';
import '../Models/reg_attendance_schedule.dart';
import '../Models/reg_mark_attendance_data.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class RegMarkAttendanceController extends GetxController {
  RxList<RegAttendanceList> attendanceDataList = <RegAttendanceList>[].obs;
  RxList<RegAttendanceList> attendanceDataCopyList = <RegAttendanceList>[].obs;
  RxList<RegMarkAttendanceData> uploadAttendanceDataList =
      <RegMarkAttendanceData>[].obs;
  RxBool isLoadingFetchAttendanceList = true.obs;
  RxBool isUploadingRegAttendance = false.obs;
  RxBool isSelectAll = true.obs;
  DateTime selectedDate = Get.arguments['selected_date'];
  int facultyId = Get.arguments['faculty_id'];
  RegSchedule scheduleData = Get.arguments['lec_data'];
  final internetController = Get.find<InternetConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceList();
  }

  Future<List<RegAttendanceList>> getAttendanceList(
      int subId, int cid, int fid, String cdate, String stime) async {
    try {
      Map<String, dynamic> body = {
        'sub_id': subId,
        'c_id': cid,
        'f_id': fid,
        'c_date': cdate,
        's_time': stime
      };
      final response = await http.post(
        Uri.parse(getAttendanceListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        List<RegAttendanceList> AttendanceDataList = responseData
            .map((attendanceData) => RegAttendanceList.fromJson(attendanceData))
            .toList();

        return AttendanceDataList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> fetchAttendanceList() async {
    isLoadingFetchAttendanceList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingFetchAttendanceList.value = false;
      Utils().showInternetAlert(
          context: Get.context!, onConfirm: () => fetchAttendanceList());
    } else {
      String formatedSelectedDate =
          DateFormat("yyyy-MM-dd").format(selectedDate);
      List<RegAttendanceList> fetchedAttendanceDataList =
          await getAttendanceList(scheduleData.subjectID, scheduleData.classID,
              facultyId, formatedSelectedDate, scheduleData.startTime);

      attendanceDataList.assignAll(fetchedAttendanceDataList);
      createAttendanceCopy();
      isLoadingFetchAttendanceList.value = false;
    }
  }

  Future<void> createAttendanceCopy() async {
    attendanceDataCopyList.value = attendanceDataList.map((attendance) {
      RegAttendanceList copiedAttendance = attendance.copyWith(
        newStatus: attendance.status == 'na' ? 'pr' : attendance.status,
      );
      return copiedAttendance;
    }).toList();
  }

  Future<void> uploadRegAttendance() async {
    isUploadingRegAttendance.value = true;
    for (int i = 0; i < attendanceDataCopyList.length; i++) {
      // Check if the status in attendanceDataCopyList is different from attendanceDataList
      if (attendanceDataList[i].status != attendanceDataCopyList[i].status) {
        uploadAttendanceDataList.add(RegMarkAttendanceData(
          subjectId: scheduleData.subjectID,
          facultyId: facultyId,
          studentId: attendanceDataCopyList[i].studentID,
          date: DateFormat("yyyy-MM-dd").format(selectedDate),
          status: attendanceDataCopyList[i].status,
          classStartTime: scheduleData.startTime,
          classEndTime: scheduleData.endTime,
          lecType: scheduleData.lecType,
        ));
      }
    }

    try {
      if (!internetController.isConnected.value) {
        isLoadingFetchAttendanceList.value = false;
        Utils().showInternetAlert(
            context: Get.context!, onConfirm: () => uploadRegAttendance());
      } else {
        if (uploadAttendanceDataList.isEmpty) {
          Utils().showNoChangesUploadAlert();
        }
        List<Map<String, dynamic>> body =
            uploadAttendanceDataList.map((data) => data.toJson()).toList();

        final response = await http.post(
          Uri.parse(uploadAttendanceAPI),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': validApiKey,
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          Utils().showUploadSuccessAlert();
        } else {
          Utils().showUploadFailedAlert();
        }
      }
    } catch (e) {
      Utils().showUploadFailedAlert();
    }
    isUploadingRegAttendance.value = false;
  }

  void handleSelectAll(bool? value) {
    isSelectAll.value = value!;
    for (var attendanceList in attendanceDataCopyList) {
      if (attendanceList.status != 'oe' && attendanceList.status != 'gl') {
        attendanceList.status = isSelectAll.value ? 'pr' : 'ab';
      }
    }
  }

  bool checkIfAllSelected() {
    return attendanceDataCopyList.where((attendanceList) {
      return attendanceList.status != 'oe' && attendanceList.status != 'gl';
    }).every((attendanceList) => attendanceList.status == 'pr');
  }
}
