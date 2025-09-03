import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Animations/zoom_in_animation.dart';
import 'package:ict_faculties/Controllers/reg_attendance_schedule_controller.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Models/reg_attendance_schedule.dart';
import 'package:ict_faculties/Screens/Loading/adaptive_loading_screen.dart';
import 'package:ict_faculties/Widgets/Refresh/adaptive_refresh_indicator.dart';
import 'package:intl/intl.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Widgets/Attendance/reg_attendance_card.dart';

import '../../Exception/no_schedule_available.dart';

class RegAttendanceSchedule extends GetView<RegAttendanceScheduleController> {
  const RegAttendanceSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter the attendance list based on the selected date
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Attendance Schedule"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Heading1(
                  context,
                  DateTime.now()
                              .difference(controller.selectedDate.value)
                              .inDays ==
                          0
                      ? "Today (${DateFormat('dd-MMM-yyyy').format(controller.selectedDate.value)})"
                      : DateFormat('dd-MMM-yyyy')
                          .format(controller.selectedDate.value),
                  2.5,
                  15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar02,
                      color: muColor,
                      size: getSize(context, 3.5),
                    )),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Obx(
            () => Expanded(
              child: AdaptiveRefreshIndicator(
                onRefresh: () => controller.fetchSchedule(
                    date: controller.selectedDate.value),
                child: controller.isLoadingFetchSchedule.value
                    ? AdaptiveLoadingScreen()
                    : controller.scheduleDataList.isNotEmpty
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.scheduleDataList.length,
                            itemBuilder: (context, index) {
                              RegSchedule schedule =
                                  controller.scheduleDataList[index];
                              return ZoomInAnimation(
                                delayMilliseconds: 100 * index,
                                child: ScheduleCard(
                                  context: context,
                                  facultyId: controller.facultyId,
                                  sem: schedule.sem,
                                  eduType: schedule.eduType,
                                  subjectId: schedule.subjectID,
                                  subjectName: schedule.subjectName,
                                  shortSubName: schedule.shortName,
                                  subType: schedule.subjectType,
                                  subCode: schedule.subjectCode,
                                  classID: schedule.classID,
                                  classname: schedule.className,
                                  batch: schedule.batch,
                                  classLoc: schedule.classLocation,
                                  lecType: schedule.lecType,
                                  startTime: schedule.startTime,
                                  endTime: schedule.endTime,
                                  selectedDate: controller.selectedDate.value,
                                  arg: schedule,
                                ),
                              );
                            },
                          )
                        : NoScheduleAvailable(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor:
                muColor, // Change the calendar header and active dates
            colorScheme: ColorScheme.light(
              primary: muColor, // Header and active dates
              onPrimary: Colors.white, // Text color of the header
              onSurface: muColor, // Text color of inactive dates
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the date picker
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != controller.selectedDate) {
      controller.selectedDate.value = picked;
      controller.fetchSchedule(date: picked);
    }
  }
}
