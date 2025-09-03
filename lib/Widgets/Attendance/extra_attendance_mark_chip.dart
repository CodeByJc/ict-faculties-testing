import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_faculties/Helper/Components.dart';

import '../../Helper/colors.dart';

class ExtAttendanceMarkChip extends StatelessWidget {
  final BuildContext context;
  final int facultyId;
  final int sem;
  final String eduType;
  final int subjectId;
  final String subjectName;
  final String shortSubName;
  final String subType;
  final String subCode;
  final int classID;
  final String classname;
  final String batch;
  final String classLoc;
  final String lecType;
  final String startTime;
  final String endTime;
  final DateTime selectedDate;
  final dynamic arg;

  const ExtAttendanceMarkChip({
    super.key,
    required this.context,
    required this.facultyId,
    required this.sem,
    required this.eduType,
    required this.subjectId,
    required this.subjectName,
    required this.shortSubName,
    required this.subType,
    required this.subCode,
    required this.classID,
    required this.classname,
    required this.batch,
    required this.classLoc,
    required this.lecType,
    required this.startTime,
    required this.endTime,
    required this.selectedDate,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getSize(context, 1.5)),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: getSize(context, 2)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(getSize(context, 2.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: getSize(context, 5),
                        left: getSize(context, 3),
                        right: getSize(context, 3)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "$shortSubName [$subCode]",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "mu_reg",
                                  fontWeight: FontWeight.bold,
                                  fontSize: getSize(context, 2.25)),
                            ),
                            Text(
                              "  - $subType",
                              style: TextStyle(
                                  color: muColor,
                                  fontFamily: "mu_reg",
                                  fontSize: getSize(context, 2.25)),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoRow("Class", classname),
                            _buildInfoRow("Batch", batch.toUpperCase()),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildIconTextRow(
                                  Icons.alarm,
                                  "${startTime.substring(0, 5)} to ${endTime.substring(0, 5)}",
                                ),
                                SizedBox(height: 5),
                                _buildIconTextRow(
                                  Icons.location_on_outlined,
                                  classLoc,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 10, 0, 25),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: _buildAttendanceButton(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildTopBanner(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label : ",
          style: TextStyle(
              color: muColor,
              fontFamily: "mu_reg",
              fontWeight: FontWeight.bold,
              fontSize: getSize(context, 2.25)),
        ),
        Text(
          value,
          style: TextStyle(
              color: Colors.black,
              fontFamily: "mu_reg",
              fontWeight: FontWeight.bold,
              fontSize: getSize(context, 2.25)),
        ),
      ],
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: muColor,
          size: getSize(context, 3.5),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "mu_reg",
              fontSize: getSize(context, 2.25),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceButton() {
    return InkWell(
      onTap: () => Get.toNamed("/markAttendance", arguments: {
        'faculty_id': facultyId,
        'lec_data': arg,
        'selected_date': selectedDate,
      }),
      child: Card(
        color: muGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          height: getHeight(context, 0.05),
          width: getWidth(context, 0.4),
          child: Center(
            child: Text(
              "Take Attendance",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: muColor,
                fontFamily: "mu_reg",
                fontSize: getSize(context, 2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Container(
        width: getWidth(context, 0.6),
        height: getHeight(context, 0.045),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(500),
          border: Border.all(color: muColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Sem - $sem -",
              style: TextStyle(
                color: muColor,
                fontFamily: "mu_reg",
                fontSize: getSize(context, 2.25),
              ),
            ),
            Text(
              eduType,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "mu_bold",
                fontSize: getSize(context, 2.25),
              ),
            ),
            Text(
              "- ${lecType == "L" ? "Lab" : "Theory"}",
              style: TextStyle(
                color: muColor,
                fontFamily: "mu_reg",
                fontSize: getSize(context, 2.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
