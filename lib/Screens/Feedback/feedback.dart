import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../../Animations/slide_zoom_in_animation.dart';
import '../../Controllers/feedback_controller.dart';
import '../../Helper/Colors.dart';
import '../../Helper/Components.dart';
import '../../Helper/Style.dart';
import '../../Helper/size.dart';
import '../../Widgets/Refresh/adaptive_refresh_indicator.dart';
import '../Loading/adaptive_loading_screen.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    String? formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }

    String? formatTime(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('hh:mm a').format(dateTime);
    }

    // Show confirmation dialog for marking feedback as viewed
    void showMarkAsViewedDialog(int feedbackId) {
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          showCancelBtn: true,
          title: "Confirm",
          text: "Are you sure you want to mark this feedback as viewed?",
          confirmButtonText: "Yes, Mark",
          cancelButtonColor: Colors.redAccent,
          cancelButtonText: "Cancel",
          confirmButtonColor: muColor,
          onConfirm: () async {
            Get.back();
            await controller.updateStatusViewed(feedbackId);
          },
          onCancel: () {},
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Anonymous Feedback",
          style: AppbarStyle,
        ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => controller.feedbackDataList.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.feedbackDataList.length,
                      itemBuilder: (context, index) {
                        final feedback = controller.feedbackDataList[index];
                        String? dateStr = formatDate(feedback.feedbackDate);
                        String? timeStr = formatTime(feedback.feedbackDate);

                        // Debug review length and expansion
                        print(
                            'Feedback ${feedback.feedbackId}: length=${feedback.feedbackReview.length}, hasNewline=${feedback.feedbackReview.contains('\n')}');

                        return SlideZoomInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: muGrey,
                                    borderRadius: BorderRadius.circular(borderRad),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedComment01,
                                            color: muColor,
                                          ),
                                          const SizedBox(width: 7),
                                          Expanded(
                                            child: Obx(
                                                  () {
                                                bool isExpanded = controller
                                                    .expandedReviews[
                                                feedback.feedbackId] ??
                                                    false;
                                                bool needsExpansion =
                                                    feedback.feedbackReview.length >
                                                        25 ||
                                                        feedback.feedbackReview
                                                            .contains('\n');

                                                // Debug expansion state
                                                print(
                                                    'Feedback ${feedback.feedbackId}: needsExpansion=$needsExpansion, isExpanded=$isExpanded');

                                                return GestureDetector(
                                                  onTap: needsExpansion
                                                      ? () {
                                                    controller.toggleReviewExpansion(
                                                        feedback.feedbackId);
                                                  }
                                                      : null,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 100), // Prevent overlap with tag
                                                        child: Text(
                                                          "Review: ${feedback.feedbackReview}",
                                                          maxLines: isExpanded ? null : 1,
                                                          overflow: isExpanded
                                                              ? null
                                                              : TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontSize: getSize(context, 2),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      if (needsExpansion)
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              top: 2, right: 100),
                                                          child: Text(
                                                            isExpanded
                                                                ? "show less"
                                                                : "show more...",
                                                            style: TextStyle(
                                                              fontSize:
                                                              getSize(context, 1.8),
                                                              color: muColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons.strokeRoundedUser,
                                            color: muColor,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                            'Sem: ${feedback.feedbackStudentSem} - ${feedback.feedbackStudentEduType.toUpperCase()}',
                                            style: TextStyle(
                                              fontSize: getSize(context, 2),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              HugeIcon(
                                                icon: HugeIcons
                                                    .strokeRoundedCalendar03,
                                                color: muColor,
                                              ),
                                              const SizedBox(width: 7),
                                              Text(
                                                dateStr ?? 'N/A',
                                                style: TextStyle(
                                                  fontSize: getSize(context, 2),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (feedback.feedbackStatus == 0)
                                            ElevatedButton(
                                              onPressed: controller
                                                  .isUpdatingFeedbackStatus.value
                                                  ? null
                                                  : () {
                                                showMarkAsViewedDialog(
                                                    feedback.feedbackId);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: muColor,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 5),
                                                minimumSize: Size(0, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Mark as Viewed',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: getSize(context, 1.6),
                                                  fontFamily: 'mu_reg',
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 100,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: feedback.feedbackStatus == 0
                                          ? Colors.amber
                                          : Colors.green,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        feedback.feedbackStatus == 0
                                            ? "Not Viewed"
                                            : "Viewed",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getSize(context, 1.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text(
                        "No feedback history found",
                        style: TextStyle(
                          fontSize: getSize(context, 2),
                          color: muGrey2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}