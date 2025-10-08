import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Models/feedback_model.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class FeedbackController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();

  RxList<FeedbackModel> feedbackDataList = <FeedbackModel>[].obs;
  RxBool isLoadingFeedbackList = true.obs;
  RxBool isUpdatingFeedbackStatus = false.obs;

  int facultyId = Get.arguments['faculty_id'];

  // Track expanded reviews
  RxMap<int, bool> expandedMap = <int, bool>{}.obs;

  // Track visible reviews
  RxMap<int, bool> visibleReviewMap = <int, bool>{}.obs;

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
              } catch (_) {
                return null;
              }
            }).whereType<FeedbackModel>().toList(),
          );

          // Initialize visibility map
          for (var fb in feedbackDataList) {
            visibleReviewMap.putIfAbsent(fb.feedbackId, () => fb.feedbackStatus == 1);
            expandedMap.putIfAbsent(fb.feedbackId, () => false);
          }
        }
      }
    } catch (e) {
      print('Error fetching feedback: $e');
    } finally {
      isLoadingFeedbackList.value = false;
    }
  }

  Future<void> markFeedbackViewed(int feedbackId) async {
    if (isUpdatingFeedbackStatus.value) return;

    isUpdatingFeedbackStatus.value = true;

    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isUpdatingFeedbackStatus.value = false;
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
        visibleReviewMap[feedbackId] = true;
        visibleReviewMap.refresh();
      }
    } catch (e) {
      print('Error updating feedback: $e');
    } finally {
      isUpdatingFeedbackStatus.value = false;
    }
  }

  void toggleReviewExpansion(int feedbackId) {
    expandedMap[feedbackId] = !(expandedMap[feedbackId] ?? false);
    expandedMap.refresh();
  }
}
