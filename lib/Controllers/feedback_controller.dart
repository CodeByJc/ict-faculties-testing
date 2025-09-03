import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Helper/Utils.dart';
import '../Models/feedback_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class FeedbackController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<FeedbackModel> feedbackDataList = <FeedbackModel>[].obs;
  RxBool isLoadingFeedbackList = true.obs;
  RxBool isUpdatingFeedbackStatus = false.obs;
  int facultyId = Get.arguments['faculty_id'];

  // Feedback history expansion state
  RxMap<int, bool> expandedReviews = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbackList();
  }

  Future<void> fetchFeedbackList() async {
    isLoadingFeedbackList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingFeedbackList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchFeedbackList(),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$feedbackHistoryAPI?faculty_id=$facultyId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['status'] == true) {
          final feedbackList = responseData['data'] as List<dynamic>;
          feedbackDataList.assignAll(
            feedbackList.map((data) {
              try {
                return FeedbackModel.fromJson(data);
              } catch (e) {
                print('Error parsing feedback: $data, error: $e');
                return null; // Skip invalid entries
              }
            }).where((feedback) => feedback != null).cast<FeedbackModel>().toList(),
          );
        } else {
          Get.snackbar(
            "No Data",
            responseData['message'] ?? 'No feedback available',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching feedback: $e');
      Get.snackbar(
        "Error",
        "Failed to get feedback data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFeedbackList.value = false;
    }
  }

  Future<void> updateStatusViewed(int feedbackId) async {
    isUpdatingFeedbackStatus.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isUpdatingFeedbackStatus.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => updateStatusViewed(feedbackId),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('$feedbackStatusUpdateAPI?feedback_id=$feedbackId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['status'] == true) {
          Get.snackbar(
            "Success",
            responseData['message'] ?? 'Feedback Status Updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          fetchFeedbackList();
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? 'Failed to update status',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final message = json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error update status: $e');
      Get.snackbar(
        "Error",
        "Failed to add feedback: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingFeedbackStatus.value = false;
    }
  }
  // Toggle expansion state for feedback items
  void toggleReviewExpansion(int feedbackId) {
    expandedReviews[feedbackId] = !(expandedReviews[feedbackId] ?? false);
  }
}