import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/reg_attendance_mark_controller.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Models/reg_attendance_list.dart';
import 'package:ict_faculties/Network/API.dart';
import 'package:ict_faculties/Screens/Exception/no_students_available.dart';
import 'package:ict_faculties/Screens/Loading/mu_loading_screen.dart';
import 'package:ict_faculties/Widgets/Refresh/adaptive_refresh_indicator.dart';
import 'package:intl/intl.dart';
import '../../../Helper/colors.dart';

class RegMarkAttendance extends GetView<RegMarkAttendanceController> {
  const RegMarkAttendance({super.key});

  void showStudentDetails(RegAttendanceList attendanceList) {
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
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Image.network(
                  studentImageAPI(attendanceList.studentGR!),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is loaded, show the child (the image itself).
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
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
        title: Text("Mark Attendance"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: AdaptiveRefreshIndicator(
        onRefresh: () => controller.fetchAttendanceList(),
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
                                  fontSize: getSize(context, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                            Text(
                              'Class ',
                              style: TextStyle(
                                  fontSize: getSize(context, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                            Text(
                              'Time ',
                              style: TextStyle(
                                  fontSize: getSize(context, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                            Text(
                              'Location ',
                              style: TextStyle(
                                  fontSize: getSize(context, 2),
                                  fontFamily: "mu_bold",
                                  color: Colors.black),
                            ),
                            Text(
                              'Date ',
                              style: TextStyle(
                                  fontSize: getSize(context, 2),
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
                            Row(
                              children: [
                                Text(
                                  ": ${controller.scheduleData.className}",
                                  style: TextStyle(
                                      fontSize: getSize(Get.context!, 2),
                                      fontFamily: "mu_bold",
                                      color: muColor),
                                ),
                                SizedBox(width: getWidth(Get.context!, 0.1)),
                                Text(
                                  'Batch ',
                                  style: TextStyle(
                                      fontSize: getSize(Get.context!, 2),
                                      fontFamily: "mu_bold",
                                      color: Colors.black),
                                ),
                                Text(
                                  ": ${controller.scheduleData.batch.toUpperCase()}",
                                  style: TextStyle(
                                      fontSize: getSize(Get.context!, 2),
                                      fontFamily: "mu_bold",
                                      color: muColor),
                                ),
                              ],
                            ),
                            Text(
                              ': ${controller.scheduleData.startTime.substring(0, 5)}  to  ${controller.scheduleData.endTime.substring(0, 5)}',
                              style: TextStyle(
                                  fontSize: getSize(Get.context!, 2),
                                  fontFamily: "mu_bold",
                                  color: muColor),
                            ),
                            Text(
                              ': ${controller.scheduleData.classLocation}',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: controller.isSelectAll.value,
                          onChanged: (value) {
                            controller.handleSelectAll(value);
                          },
                          activeColor: muColor,
                        ),
                        Text(
                          'Select All',
                          style: TextStyle(
                              fontFamily: "mu_bold",
                              fontSize: getSize(Get.context!, 2.5)),
                        ),
                      ],
                    ),
                    Divider(),
                    Expanded(
                        child: controller.isLoadingFetchAttendanceList.value
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: muColor,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : controller.attendanceDataCopyList.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller
                                        .attendanceDataCopyList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // 2 items per row
                                      crossAxisSpacing:
                                          10.0, // spacing between items horizontally
                                      mainAxisSpacing:
                                          5.0, // spacing between items vertically
                                      childAspectRatio:
                                          3, // controls the size of each tile, adjust this for the desired look
                                    ),
                                    itemBuilder: (context, index) {
                                      bool isDisabled = controller
                                                  .attendanceDataCopyList[index]
                                                  .status ==
                                              'oe' ||
                                          controller
                                                  .attendanceDataCopyList[index]
                                                  .status ==
                                              'gl';

                                      return InkWell(
                                        onHover: (value) => Tooltip(message: controller.attendanceDataCopyList[index].studentName!,),
                                        onLongPress: () => showStudentDetails(
                                            controller
                                                .attendanceDataCopyList[index]),
                                        onTap: isDisabled
                                            ? null
                                            : () {
                                                controller
                                                    .attendanceDataCopyList[
                                                        index]
                                                    .status = controller
                                                            .attendanceDataCopyList[
                                                                index]
                                                            .status ==
                                                        'pr'
                                                    ? 'ab'
                                                    : 'pr';
                                                controller
                                                    .attendanceDataCopyList
                                                    .refresh();
                                                controller.isSelectAll.value =
                                                    controller
                                                        .checkIfAllSelected();
                                              },
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Container(
                                            height:
                                                getHeight(Get.context!, 0.05),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 2,
                                                color: isDisabled
                                                    ? Colors.green
                                                    : controller
                                                                .attendanceDataCopyList[
                                                                    index]
                                                                .status ==
                                                            "pr"
                                                        ? muColor
                                                        : Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(500.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    controller
                                                        .attendanceDataCopyList[
                                                            index]
                                                        .enrollment!,
                                                    style: TextStyle(
                                                      fontFamily: 'mu_reg',
                                                      fontSize: getSize(
                                                          Get.context!, 2.3),
                                                      color: isDisabled
                                                          ? Colors.green
                                                          : controller
                                                                      .attendanceDataCopyList[
                                                                          index]
                                                                      .status ==
                                                                  "pr"
                                                              ? muColor
                                                              : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Transform.scale(
                                                  scale: 1.2,
                                                  child: Checkbox(
                                                    value: controller
                                                            .attendanceDataCopyList[
                                                                index]
                                                            .status ==
                                                        'pr',
                                                    onChanged: isDisabled
                                                        ? null
                                                        : (value) {
                                                            controller
                                                                    .attendanceDataCopyList[
                                                                        index]
                                                                    .status =
                                                                value!
                                                                    ? 'pr'
                                                                    : 'ab';
                                                            controller
                                                                .attendanceDataCopyList
                                                                .refresh();
                                                            controller
                                                                    .isSelectAll
                                                                    .value =
                                                                controller
                                                                    .checkIfAllSelected();
                                                          },
                                                    checkColor: Colors.white,
                                                    shape: CircleBorder(),
                                                    side: BorderSide(
                                                      color: isDisabled
                                                          ? Colors.green
                                                          : Colors.red,
                                                      width: 2,
                                                    ),
                                                    activeColor: isDisabled
                                                        ? Colors.green
                                                        : controller
                                                                    .attendanceDataCopyList[
                                                                        index]
                                                                    .status ==
                                                                "pr"
                                                            ? muColor
                                                            : Colors.red,
                                                    fillColor: isDisabled
                                                        ? WidgetStateProperty
                                                            .resolveWith<Color>(
                                                            (Set<WidgetState>
                                                                states) {
                                                              return Colors
                                                                  .green; // Disabled state color
                                                            },
                                                          )
                                                        : null,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : NoStudentsAvailable()),
                    // Save button
                    Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.question,
                              sizeSuccessIcon: 70,
                              confirmButtonText:
                                  "SUBMIT", // Hides the confirm button
                              confirmButtonColor: muColor,
                              onConfirm: () async {
                                Get.back();
                                controller.uploadRegAttendance.call();
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
                  ],
                ),
              ),
              controller.isUploadingRegAttendance.value
                  ? MuLoadingScreen()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
