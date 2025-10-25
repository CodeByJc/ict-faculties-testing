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

  String? _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (_) {
      return null;
    }
  }

  Widget _buildFeedbackCard(BuildContext context, feedback) {
    final feedbackId = feedback.feedbackId;
    final reviewText = (feedback.feedbackReview ?? '').trim();

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
              // Main content: leave space on right for the button
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        HugeIcon(icon: HugeIcons.strokeRoundedComment01, color: muColor),
                        const SizedBox(width: 7),
                        Text(
                          "Feedback",
                          style: TextStyle(fontSize: getSize(context, 2), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Review area: hidden until viewed, then shows text with expand/collapse
                    Obx(() {
                      final isViewed = controller.visibleReviewMap[feedbackId] ?? false;
                      final isExpanded = controller.expandedMap[feedbackId] ?? false;

                      if (!isViewed) {
                        // Not viewed -> show hint only (actual viewing triggered by the "View Review" button)
                        return Text(
                          "",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontStyle: FontStyle.italic,
                            fontSize: getSize(context, 1),
                          ),
                        );
                      }

                      // Viewed -> show review with optional expand/collapse
                      const int maxChars = 140;
                      final isLong = reviewText.length > maxChars;
                      final displayText = (!isExpanded && isLong) ? reviewText.substring(0, maxChars) + '...' : reviewText;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayText,
                            style: TextStyle(fontSize: getSize(context, 2), fontWeight: FontWeight.bold),
                          ),
                          if (isLong)
                            GestureDetector(
                              onTap: () => controller.toggleReviewExpansion(feedbackId),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  isExpanded ? 'Show less' : 'Show more',
                                  style: TextStyle(fontSize: getSize(context, 1.8), color: muColor, fontWeight: FontWeight.bold),
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
                        HugeIcon(icon: HugeIcons.strokeRoundedUser, color: muColor),
                        const SizedBox(width: 7),
                        Text(
                          'Sem: ${feedback.feedbackStudentSem ?? ''} - ${(feedback.feedbackStudentEduType ?? '').toString().toUpperCase()}',
                          style: TextStyle(fontSize: getSize(context, 2)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        HugeIcon(icon: HugeIcons.strokeRoundedCalendar03, color: muColor),
                        const SizedBox(width: 7),
                        Text(
                          _formatDate(feedback.feedbackDate) ?? 'N/A',
                          style: TextStyle(fontSize: getSize(context, 2)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Top-right button: "View Review" when not viewed, "Viewed" (disabled) when viewed
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() {
                  final isViewed = controller.visibleReviewMap[feedbackId] ?? false;

                  return SizedBox(
                    width: 122,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: isViewed ? null : () async { await controller.markFeedbackViewed(feedbackId); },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isViewed ? Colors.green : orangeColor,
                        disabledBackgroundColor: Colors.green, // ensure disabled state is green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isViewed ? 'Viewed' : 'View Review',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
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
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                children: controller.feedbackDataList.isEmpty
                    ? [
                  Center(
                    child: Text(
                      "No feedback history found",
                      style: TextStyle(fontSize: getSize(context, 2), color: muGrey2),
                    ),
                  )
                ]
                    : controller.feedbackDataList.map<Widget>((f) => _buildFeedbackCard(context, f)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}