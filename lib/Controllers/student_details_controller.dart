import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Models/student_detail_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class StudentDetailsController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  Rx<StudentDetailsModel?> student = Rx<StudentDetailsModel?>(null);
  RxBool isSearchingStudent = false.obs;

  Future<void> searchStudent(String enroll) async {
    print("-----------------------------------"+enroll);
    isSearchingStudent.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isSearchingStudent.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => searchStudent(enroll),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(studentDetailsAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
        body: json.encode({'enrolment': enroll}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['status'] == true) {
          student.value = StudentDetailsModel.fromJson(responseData['data']);
        } else {
          student.value = null;
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No student data available',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            mainButton: TextButton(
              onPressed: () => searchStudent(enroll),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          );
        }
      } else {
        student.value = null;
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () => searchStudent(enroll),
            child: Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    } catch (e) {
      student.value = null;
      print('Error fetching student details: $e');
      Get.snackbar(
        "Error",
        "Failed to get student data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => searchStudent(enroll),
          child: Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      isSearchingStudent.value = false;
    }
  }
}