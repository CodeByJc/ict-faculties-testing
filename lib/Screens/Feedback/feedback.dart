import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../Animations/slide_zoom_in_animation.dart';
import '../../Controllers/feedback_controller.dart';
import '../../Helper/colors.dart';
import '../../Helper/Components.dart';
import '../../Helper/Style.dart';
import '../../Helper/size.dart';
import '../../Widgets/Refresh/adaptive_refresh_indicator.dart';
import '../Loading/adaptive_loading_screen.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Anonymous Feedback", style: AppbarStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
            () => controller.isLoadingFeedbackList.value
            ? const AdaptiveLoadingScreen()
            : AdaptiveRefreshIndicator(
          onRefresh: () => controller.fetchFeedbackList(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: controller.feedbackDataList.isEmpty
                    ? [
                  Center(
                    child: Text(
                      "No feedback history found",
                      style: TextStyle(
                        fontSize: getSize(context, 2),
                        color: muGrey2,
                      ),
                    ),
                  )
                ]
                    : controller.feedbackDataList.map((feedback) {
                  return SlideZoomInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: muGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, right: 110),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Feedback Title
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedComment01,
                                        color: muColor,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        "Feedback",
                                        style: TextStyle(
                                          fontSize: getSize(context, 2),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Review Content
                                  Obx(() {
                                    bool isVisible = controller.visibleReviewMap[feedback.feedbackId] ?? false;
                                    bool isExpanded = controller.expandedMap[feedback.feedbackId] ?? false;

                                    if (!isVisible) {
                                      return Text(
                                        "Review hidden until viewed.",
                                        style: TextStyle(
                                          color: muGrey2,
                                          fontStyle: FontStyle.italic,
                                          fontSize: getSize(context, 1.8),
                                        ),
                                      );
                                    }

                                    String fullText = feedback.feedbackReview;
                                    const int maxChars = 40;
                                    bool isLong = fullText.length > maxChars;
                                    String displayText = (!isExpanded && isLong)
                                        ? fullText.substring(0, maxChars) + "..."
                                        : fullText;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayText,
                                          style: TextStyle(
                                            fontSize: getSize(context, 2),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (isLong)
                                          GestureDetector(
                                            onTap: () {
                                              controller.toggleReviewExpansion(feedback.feedbackId);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                isExpanded ? "Show Less" : "Show More",
                                                style: TextStyle(
                                                  fontSize: getSize(context, 1.8),
                                                  fontWeight: FontWeight.bold,
                                                  color: muColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),

                                  const SizedBox(height: 10),

                                  // Student info + date
                                  Row(
                                    children: [
                                      HugeIcon(
                                          icon: HugeIcons.strokeRoundedUser,
                                          color: muColor),
                                      const SizedBox(width: 7),
                                      Text(
                                        'Sem: ${feedback.feedbackStudentSem} - ${feedback.feedbackStudentEduType.toUpperCase()}',
                                        style: TextStyle(fontSize: getSize(context, 2)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      HugeIcon(
                                          icon: HugeIcons.strokeRoundedCalendar03,
                                          color: muColor),
                                      const SizedBox(width: 7),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(DateTime.parse(feedback.feedbackDate)),
                                        style: TextStyle(fontSize: getSize(context, 2)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Top Right Viewed Button
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Obx(() {
                                bool isViewed = controller.visibleReviewMap[feedback.feedbackId] ?? false;
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    onTap: isViewed
                                        ? null
                                        : () async {
                                      await controller.markFeedbackViewed(feedback.feedbackId);
                                    },
                                    child: Ink(
                                      width: 100,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: isViewed ? Colors.green : Colors.amber,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            blurRadius: 4,
                                            offset: const Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          isViewed ? "Viewed" : "Not Viewed",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: getSize(context, 1.8),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
