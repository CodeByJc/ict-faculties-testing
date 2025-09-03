import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_faculties/Helper/Style.dart';
import '../../../Controllers/attendance_show_controller.dart';
import '../../../Helper/Colors.dart';
import '../../../Helper/Components.dart';
import '../../../Widgets/Refresh/adaptive_refresh_indicator.dart';
import '../../../Widgets/heading_1.dart';
import '../../Loading/adaptive_loading_screen.dart';

class StudentAttendanceScreen extends GetView<AttendanceShowController> {
  const StudentAttendanceScreen({super.key});

  Future<void> _refreshData() async {
    await controller.fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total attendance and present lectures

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Student Attendance", style: AppbarStyle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: muColor,
        automaticallyImplyLeading: false,
      ),
      body: AdaptiveRefreshIndicator(
        onRefresh: () => _refreshData(),
        child: ListView(
          children: [
            controller.isLoadingAttendanceShow.value
                ? const AdaptiveLoadingScreen()
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Obx(
                        () => Column(
                          children: [
                            Heading2(
                                text: "${controller.studentName.split(' ')[0]}'s Attendance Report",
                                fontSize: 2.5,
                                leftPadding: 8),
                            controller.attendanceList.isNotEmpty
                                ? Center(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          child: Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(getSize(
                                                  context, 0.1)), // Subject
                                              1: FlexColumnWidth(getSize(
                                                  context, 0.04)), // Lec Type
                                              2: FlexColumnWidth(getSize(
                                                  context, 0.06)), // Total
                                              3: FlexColumnWidth(getSize(
                                                  context, 0.06)), // Present
                                              4: FlexColumnWidth(getSize(
                                                  context, 0.06)), // Extra
                                              5: FlexColumnWidth(
                                                  getSize(context, 0.08)), // %
                                            },
                                            border: const TableBorder(
                                              verticalInside: BorderSide(),
                                            ),
                                            children: [
                                              // Table Heading
                                              TableRow(
                                                decoration: BoxDecoration(
                                                    color:
                                                        muColor), // Header background color
                                                children: [
                                                  Center(
                                                    child: TableCell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Sub',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors
                                                                .white, // Set text color to black
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const TableCell(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(''),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Tot',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Pre',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Ext',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '%',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'mu_bold',
                                                            fontSize: getSize(
                                                                context, 2.25),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Table Rows with merged subjectShortName and custom border handling
                                              ...controller
                                                  .buildMergedTableRows(),
                                            ],
                                          ),
                                        )),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('No attendance data found',
                                            style: TextStyle(
                                                fontFamily: "mu_reg",
                                                fontSize: getSize(context, 2))),
                                      ],
                                    ),
                                  ),
                            const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Divider(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
