import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Network/API.dart';
import 'package:ict_faculties/Models/punch_model.dart';

class PunchController extends GetxController {
  RxBool hasPunchedIn = false.obs;
  RxBool hasPunchedOut = false.obs;
  RxList<PunchModel> attendanceHistory = <PunchModel>[].obs;
  RxBool isHolidayOrSunday = false.obs;
  int facultyId = Get.arguments['faculty_id'];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final String currentDate = DateTime.now().toString().split(' ')[0];
    fetchAttendanceInfo(facultyId, currentDate);
    getAttendanceHistory(facultyId);
  }

  Future<PunchModel> fetchAttendanceInfo(int facultyId, String date) async {
    isLoading.value=true;
    try {
      final response = await http.post(
        Uri.parse(facultyPunch),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          "action": "primary",
          "faculty_info_id": facultyId,
          "date": date,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print('Fetch Response: $jsonData');
        PunchModel data = PunchModel.fromJson({
          'status': jsonData['status'],
          'message': jsonData['message'],
          'id': jsonData['data']?['id'],
          'punch_in': jsonData['data']?['punch_in'],
          'punch_out': jsonData['data']?['punch_out'],
          'date': jsonData['data']?['date'],
          'faculty_info_id': jsonData['data']?['faculty_info_id'],
        });
        hasPunchedIn.value = data.punchIn != null;
        hasPunchedOut.value = data.punchOut != null;
        isHolidayOrSunday.value = !data.status && data.message.contains('holiday or Sunday');
        return data;
      } else {
        return PunchModel(status: false, message: 'Failed to fetch attendance info');
      }
    } catch (e) {
      print('Fetch Error: $e');
      return PunchModel(status: false, message: 'Error: $e');
    }finally{
      isLoading.value=false;
    }
  }

  Future<bool> punchIn(int facultyId, String date, String punchInTime) async {
    isLoading.value=true;
    try {
      final response = await http.post(
        Uri.parse(facultyPunch),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          'action': 'punchIn',
          'faculty_info_id': facultyId,
          'date': date,
          'punch_in': punchInTime,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print('PunchIn Response: $jsonData');
        PunchModel data = PunchModel.fromJson(jsonData);
        if (data.status) {
          hasPunchedIn.value = true;
          await getAttendanceHistory(facultyId);
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print('Punch In Error: $e');
      return false;
    }finally{
      isLoading.value=false;
    }
  }

  Future<bool> punchOut(int facultyId, String date, String punchOutTime) async {
    isLoading.value=true;
    try {
      final response = await http.post(
        Uri.parse(facultyPunch),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          'action': 'punchOut',
          'faculty_info_id': facultyId,
          'date': date,
          'punch_out': punchOutTime,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print('PunchOut Response: $jsonData');
        PunchModel data = PunchModel.fromJson(jsonData);
        if (data.status) {
          hasPunchedOut.value = true;
          await getAttendanceHistory(facultyId);
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print('Punch Out Error: $e');
      return false;
    }finally{
      isLoading.value=false;
    }
  }

  Future<bool> getAttendanceHistory(int facultyId) async {
    isLoading.value=true;
    try {
      final response = await http.post(
        Uri.parse(facultyPunch),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({
          "action": "history",
          "faculty_info_id": facultyId,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print('History Response: $jsonData');
        if (jsonData['status']) {
          attendanceHistory.value = (jsonData['data'] as List)
              .map((item) => PunchModel.fromJson(item))
              .toList();
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      print('History Error: $e');
      return false;
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> refreshData() async {
    final String currentDate = DateTime.now().toString().split(' ')[0];
    await fetchAttendanceInfo(facultyId, currentDate);
    await getAttendanceHistory(facultyId);
  }

  void resetAttendanceState() {
    hasPunchedIn.value = false;
    hasPunchedOut.value = false;
    isHolidayOrSunday.value = false;
    attendanceHistory.clear();
  }
}