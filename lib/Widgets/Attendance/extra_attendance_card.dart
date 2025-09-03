import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Helper/size.dart';

class ExtraScheduleCard extends StatelessWidget {
  final BuildContext context;
  final int facultyId;
  final int semId;
  final int sem;
  final String eduType;
  final String lecType;
  final int subjectId;
  final String subjectName;
  final String shortSubName;
  final String subType;
  final String subCode;
  final DateTime selectedDate;
  final dynamic arg;

  const ExtraScheduleCard({
    super.key,
    required this.context,
    required this.facultyId,
    required this.semId,
    required this.sem,
    required this.eduType,
    required this.lecType,
    required this.subjectId,
    required this.subjectName,
    required this.shortSubName,
    required this.subType,
    required this.subCode,
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
                  color: backgroundColor,
                  border: Border.all(color: muGrey, width: 1.5),
                  borderRadius: BorderRadius.circular(getSize(context, 2.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 5,
                    ),
                  ]),
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
                            SizedBox(
                              width: getWidth(context, 0.8),
                              child: Text(
                                subjectName,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "mu_reg",
                                    fontWeight: FontWeight.bold,
                                    fontSize: getSize(context, 2.25)),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Short :   ",
                                  style: TextStyle(
                                      color: muColor,
                                      fontFamily: "mu_reg",
                                      fontWeight: FontWeight.bold,
                                      fontSize: getSize(context, 2.25)),
                                ),
                                Text(
                                  shortSubName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "mu_reg",
                                      fontWeight: FontWeight.bold,
                                      fontSize: getSize(context, 2.25)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Code   :   ",
                                  style: TextStyle(
                                      color: muColor,
                                      fontFamily: "mu_reg",
                                      fontWeight: FontWeight.bold,
                                      fontSize: getSize(context, 2.25)),
                                ),
                                Text(
                                  subCode,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "mu_reg",
                                      fontWeight: FontWeight.bold,
                                      fontSize: getSize(context, 2.25)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () => Get.toNamed("/markExtraAttendance",
                                  arguments: {
                                    'faculty_id': facultyId,
                                    'subject_id': subjectId,
                                    'schedule': arg,
                                    'selected_date': selectedDate,
                                  }),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: muGrey,
                                  borderRadius:
                                      BorderRadius.circular(borderRad),
                                ),
                                child: SizedBox(
                                  height: getHeight(context, 0.05),
                                  child: Center(
                                    child: Text(
                                      "Take Attendance",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: muColor,
                                          fontFamily: "mu_reg",
                                          fontSize: getSize(context, 2)),
                                    ),
                                  ),
                                ),
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
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Container(
              width: getWidth(context, 0.5),
              height: getHeight(context, 0.045),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(500),
                  border: Border.all(color: muColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sem - $sem -",
                    style: TextStyle(
                        color: muColor,
                        fontFamily: "mu_reg",
                        fontSize: getSize(context, 2.25)),
                  ),
                  Text(
                    eduType,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "mu_bold",
                        fontSize: getSize(context, 2.25)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
