import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Models/engage_student.dart';
import 'package:ict_faculties/Models/student.dart';
import 'package:ict_faculties/Network/API.dart';

class StudentController extends GetxController {
  Future<List<Student>?> getStudentsByCC(int fid) async {
    try {
      Map<String, dynamic> body = {
        'f_id': fid,
      };

      final response = await http.post(
        Uri.parse(getStudentByCCAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Decode response body as List<dynamic>
        List<dynamic> responseData = json.decode(response.body);

        // Map to List<EngagedStudent> using fromJson
        List<Student> studentDataList =
            responseData.map((json) => Student.fromJson(json)).toList();
        return studentDataList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<EngagedStudent>?> getEngageStudentsByCC(int fid) async {
    try {
      Map<String, dynamic> body = {
        'f_id': fid,
      };

      final response = await http.post(
        Uri.parse(getEngagedStudentByCCAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Decode response body as List<dynamic>
        List<dynamic> responseData = json.decode(response.body);

        // Map to List<EngagedStudent> using fromJson
        List<EngagedStudent> engagedStudentDataList =
            responseData.map((json) => EngagedStudent.fromJson(json)).toList();
        return engagedStudentDataList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
