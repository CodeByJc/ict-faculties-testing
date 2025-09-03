import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/extra_attendance_mark_controller.dart';
import 'package:ict_faculties/Models/extra_attendance_list.dart';
import 'package:ict_faculties/Network/API.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Screens/Loading/adaptive_loading_screen.dart';
import 'package:ict_faculties/Screens/Loading/mu_loading_screen.dart';
import 'package:ict_faculties/Widgets/Refresh/adaptive_refresh_indicator.dart';
import 'package:intl/intl.dart';

import '../../Exception/no_students_available.dart';

class MarkExtraAttendance extends GetView<ExtraMarkAttendanceController> {
  const MarkExtraAttendance({super.key});

  void showStudentDetails(ExtraAttendanceList attendanceList) {
    Get.defaultDialog(
      title: "Student Details",
      titleStyle: TextStyle(
          fontFamily: 'mu_bold', fontSize: getSize(Get.context!, 2.5)),
      titlePadding: EdgeInsets.only(left: 15, right: 15, top: 15),
      content: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Center(
              child: Container(
                height: getHeight(Get.context!, 0.15),
                width: getWidth(Get.context!, 0.30),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: muGrey,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Image.network(
                  studentImageAPI(attendanceList.studentGR!),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation(muColor),
                          strokeWidth: 2,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Divider(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enroll ',
                      style: TextStyle(
                          fontSize: getSize(Get.context!, 2),
                          fontFamily: "mu_reg",
                          color: muColor),
                    ),
                    Text(
                      'Name ',
                      style: TextStyle(
                          fontSize: getSize(Get.context!, 2),
                          fontFamily: "mu_reg",
                          color: muColor),
                    ),
                    Text(
                      'Class ',
                      style: TextStyle(
                          fontSize: getSize(Get.context!, 2),
                          fontFamily: "mu_reg",
                          color: muColor),
                    ),
                    Text(
                      'Batch ',
                      style: TextStyle(
                          fontSize: getSize(Get.context!, 2),
                          fontFamily: "mu_reg",
                          color: muColor),
                    ),
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ": ${attendanceList.enrollment!}",
                        style: TextStyle(
                            fontSize: getSize(Get.context!, 2),
                            fontFamily: "mu_reg",
                            color: Colors.black),
                      ),
                      Text(
                        ": ${attendanceList.studentName!}",
                        style: TextStyle(
                            fontSize: getSize(Get.context!, 2),
                            fontFamily: "mu_reg",
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        ": ${attendanceList.classname!}",
                        style: TextStyle(
                            fontSize: getSize(Get.context!, 2),
                            fontFamily: "mu_reg",
                            color: Colors.black),
                      ),
                      Text(
                        ": ${attendanceList.classBatch!.toUpperCase()}",
                        style: TextStyle(
                            fontSize: getSize(Get.context!, 2),
                            fontFamily: "mu_reg",
                            color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Mark Extra Attendance"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: AdaptiveRefreshIndicator(
        onRefresh: () => controller.fetchExtraAttendanceList(),
        child: Obx(
          () => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject ',
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                            Text(
                              'Sem ',
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                            Text(
                              'Date ',
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ': ${controller.scheduleData.shortName} - [${controller.scheduleData.subjectCode}]',
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: muColor),
                            ),
                            Text(
                              ": ${controller.scheduleData.sem} - ${controller.scheduleData.eduType}",
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: muColor),
                            ),
                            Text(
                              ': ${DateFormat('dd / MM / yyyy').format(controller.selectedDate)}',
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: muColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Expanded(
                        child: controller.isLoadingExtraAttendanceList.value
                            ? AdaptiveLoadingScreen()
                            : controller.extraAttendanceDataCopyList.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller
                                        .extraAttendanceDataCopyList.length,
                                    itemBuilder: (context, index) {
                                      ExtraAttendanceList attendanceList =
                                          controller
                                                  .extraAttendanceDataCopyList[
                                              index];
                                      return InkWell(
                                        onLongPress: () =>
                                            showStudentDetails(attendanceList),
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 2,
                                                color: attendanceList.count != 0
                                                    ? muColor
                                                    : Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(500.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 7, 0, 7),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: SizedBox(
                                                      width: getWidth(
                                                          Get.context!, 0.6),
                                                      // color: Colors.red,
                                                      child: Text(
                                                        "${attendanceList.enrollment!} - ${attendanceList.studentName}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'mu_reg',
                                                          fontSize: getSize(
                                                              Get.context!,
                                                              2.3),
                                                          color: attendanceList
                                                                      .count !=
                                                                  0
                                                              ? muColor
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 10, 0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (controller
                                                                      .extraAttendanceDataCopyList[
                                                                          index]
                                                                      .count! >
                                                                  0) {
                                                                controller
                                                                    .extraAttendanceDataCopyList[
                                                                        index]
                                                                    .count = controller
                                                                        .extraAttendanceDataCopyList[
                                                                            index]
                                                                        .count! -
                                                                    1;
                                                              }
                                                              controller
                                                                  .extraAttendanceDataCopyList
                                                                  .refresh();
                                                            },
                                                            child: Container(
                                                              height: getSize(
                                                                  Get.context!,
                                                                  4),
                                                              width: getSize(
                                                                  Get.context!,
                                                                  4),
                                                              decoration: BoxDecoration(
                                                                  color: attendanceList
                                                                              .count !=
                                                                          0
                                                                      ? muColor
                                                                      : Colors
                                                                          .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              500)),
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          attendanceList.count
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                Get.context!,
                                                                2.5),
                                                            color: attendanceList
                                                                        .count !=
                                                                    0
                                                                ? muColor
                                                                : Colors.red,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  10, 0, 0, 0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .extraAttendanceDataCopyList[
                                                                      index]
                                                                  .count = controller
                                                                      .extraAttendanceDataCopyList[
                                                                          index]
                                                                      .count! +
                                                                  1;
                                                              controller
                                                                  .extraAttendanceDataCopyList
                                                                  .refresh();
                                                            },
                                                            child: Container(
                                                              height: getSize(
                                                                  Get.context!,
                                                                  4),
                                                              width: getSize(
                                                                  Get.context!,
                                                                  4),
                                                              decoration: BoxDecoration(
                                                                  color: attendanceList
                                                                              .count !=
                                                                          0
                                                                      ? muColor
                                                                      : Colors
                                                                          .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              500)),
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : NoStudentsAvailable()),
                    // Save button
                    controller.extraAttendanceDataCopyList.isNotEmpty
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                ArtSweetAlert.show(
                                  context: Get.context!,
                                  artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.question,
                                    sizeSuccessIcon: 70,
                                    confirmButtonText: "SUBMIT",
                                    confirmButtonColor: muColor,
                                    onConfirm: () async {
                                      Get.back();
                                      controller.uploadExtraAttendance();
                                    },
                                    title: "Confirm Attendance",
                                    dialogDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: muColor,
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedBookmark03,
                                color: Colors.white,
                              ),
                              label: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontFamily: 'mu_bold', color: Colors.white),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              controller.isUploadingExtraAttendance.value
                  ? MuLoadingScreen()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
