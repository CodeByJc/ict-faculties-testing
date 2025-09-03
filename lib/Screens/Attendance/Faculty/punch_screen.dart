import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/punch_controller.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Helper/size.dart';
import 'package:ict_faculties/Screens/Loading/adaptive_loading_screen.dart';
import 'package:ict_faculties/Widgets/Refresh/adaptive_refresh_indicator.dart';
import 'package:intl/intl.dart';
import '../../../Animations/zoom_in_animation.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class PunchScreen extends GetView<PunchController> {
  const PunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String displayDate = DateFormat('dd-MM-yyyy, EEEE').format(DateTime.now());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Punch Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return controller.isLoading.value?AdaptiveLoadingScreen():AdaptiveRefreshIndicator(
          onRefresh: controller.refreshData,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,5,0,0),
                child: Heading1(context, displayDate, 2.5, 15),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: controller.isHolidayOrSunday.value
                    ? const Text(
                        'Today is Holiday',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : (controller.hasPunchedIn.value &&
                            controller.hasPunchedOut.value)
                        ? SizedBox(
                          height: 50,
                          child: Center(
                            child: const Text(
                                'You have completed today\'s punch in and out.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                          ),
                        )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Punch In Button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: ContinuousRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(borderRad * 2)),
                                  backgroundColor: controller.hasPunchedIn.value
                                      ? muGrey
                                      : muColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                onPressed: controller.hasPunchedIn.value
                                    ? null
                                    : () {
                                        ArtSweetAlert.show(
                                          context: Get.context!,
                                          artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.question,
                                            sizeSuccessIcon: 70,
                                            showCancelBtn: true,
                                            confirmButtonText: "Yes I confirm",
                                            confirmButtonColor: muColor,
                                            cancelButtonColor: Colors.redAccent,
                                            cancelButtonText: "Cancel",
                                            onConfirm: () async {
                                              Get.back();
                                              String punchInTime =
                                                  DateFormat('HH:mm:ss')
                                                      .format(DateTime.now());
                                              bool success =
                                                  await controller.punchIn(
                                                      controller.facultyId,
                                                      currentDate,
                                                      punchInTime);
                                              if (success) {
                                                Get.snackbar('Success',
                                                    'Punched in successfully',
                                                    backgroundColor: Colors.green,
                                                    colorText: Colors.white);
                                                await controller
                                                    .getAttendanceHistory(
                                                        controller.facultyId);
                                              } else {
                                                Get.snackbar(
                                                    'Error', 'Failed to punch in',
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              }
                                            },
                                            title: "Are you sure to punch in?",
                                            dialogDecoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        );
                                      },
                                child: const Text(
                                  'Punch In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),

                              // Punch Out Button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: ContinuousRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(borderRad * 2)),
                                  backgroundColor:
                                      (!controller.hasPunchedIn.value ||
                                              controller.hasPunchedOut.value)
                                          ? muGrey
                                          : muColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                onPressed: (!controller.hasPunchedIn.value ||
                                        controller.hasPunchedOut.value)
                                    ? null
                                    : () {
                                        ArtSweetAlert.show(
                                          context: Get.context!,
                                          artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.question,
                                            sizeSuccessIcon: 70,
                                            showCancelBtn: true,
                                            confirmButtonText: "Yes I confirm",
                                            confirmButtonColor: muColor,
                                            cancelButtonColor: Colors.redAccent,
                                            cancelButtonText: "Cancel",
                                            onConfirm: () async {
                                              Get.back();
                                              String punchOutTime =
                                                  DateFormat('HH:mm:ss')
                                                      .format(DateTime.now());
                                              bool success =
                                                  await controller.punchOut(
                                                      controller.facultyId,
                                                      currentDate,
                                                      punchOutTime);
                                              if (success) {
                                                Get.snackbar('Success',
                                                    'Punched out successfully',
                                                    backgroundColor: Colors.green,
                                                    colorText: Colors.white);
                                                await controller
                                                    .getAttendanceHistory(
                                                        controller.facultyId);
                                              } else {
                                                Get.snackbar('Error',
                                                    'Failed to punch out',
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              }
                                            },
                                            title: "Are you sure to punch out?",
                                            dialogDecoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                  borderRad),
                                            ),
                                          ),
                                        );
                                      },
                                child: Text(
                                  'Punch Out',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
              ),
              SizedBox(
                height: 20,
                child: Divider(color: muGrey2,indent: 20,endIndent: 20,),
              ),
              Heading1(context, "Punch History", 2.5, 15),
              Expanded(
                child: controller.attendanceHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'No attendance history available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          itemCount: controller.attendanceHistory.length,
                          itemBuilder: (context, index) {
                            final punch = controller.attendanceHistory[index];
                            return ZoomInAnimation(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,10,0,10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: muGrey,
                                  borderRadius: BorderRadius.circular(borderRad),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedCalendar01,
                                              color: muColor),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateFormat('yyyy-MM-dd').parse(
                                                    punch.date.toString())),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: Divider(
                                          color: muGrey2,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              HugeIcon(
                                                  icon: HugeIcons
                                                      .strokeRoundedLogin02,
                                                  color: muColor),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                DateFormat('hh:mm a').format(
                                                    DateFormat('HH:mm:ss').parse(
                                                        punch.punchIn
                                                            .toString())),
                                                style:
                                                    const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              HugeIcon(
                                                  icon: HugeIcons
                                                      .strokeRoundedLogout02,
                                                  color: muColor),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(punch.punchOut != null ?
                                                DateFormat('hh:mm a').format(
                                                    DateFormat('HH:mm:ss').parse(
                                                        punch.punchOut
                                                            .toString())):"Not Punch Out",
                                                style:
                                                    const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
