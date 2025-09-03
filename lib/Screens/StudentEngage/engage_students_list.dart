import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/student_engaged_controller.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Models/engage_student.dart';
import 'package:ict_faculties/Screens/Exception/data_not_found.dart';
import 'package:ict_faculties/Screens/Loading/adaptive_loading_screen.dart';
import 'package:intl/intl.dart';

import '../../Helper/Components.dart';
import '../../Helper/size.dart';

class EngagedStudentScreen extends StatefulWidget {
  const EngagedStudentScreen({super.key});

  @override
  State<EngagedStudentScreen> createState() => _EngagedStudentScreenState();
}

class _EngagedStudentScreenState extends State<EngagedStudentScreen>
    with SingleTickerProviderStateMixin {
  late int facId;
  late String facDesignation;
  bool isLoading = false;
  List<EngagedStudent>? engagedStudentsDataList;
  List<EngagedStudent>? filteredStudentsDataList;
  final StudentController studentController = Get.put(StudentController());
  late TabController _tabController;
  final TextEditingController searchController = TextEditingController();
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    facId = Get.arguments['faculty_id'];
    facDesignation = Get.arguments['faculty_des'];
    _tabController = TabController(
      length: isHOD() ? 4 : 3,
      vsync: this,
    );
    fetchEngagedStudentDetail();
    searchController.addListener(() {
      filterStudentsBySearch(searchController.text);
    });
  }

  Future<void> fetchEngagedStudentDetail() async {
    setState(() {
      isLoading = true;
    });

    // Fetch the data
    List<EngagedStudent>? fetchedData =
        await studentController.getEngageStudentsByCC(facId);
    if (!mounted) return;

    setState(() {
      engagedStudentsDataList = fetchedData;
      filteredStudentsDataList = List.from(engagedStudentsDataList ?? []);
      isLoading = false;
    });
  }

  void filterStudentsBySearch(String query) {
    setState(() {
      filteredStudentsDataList =
          (engagedStudentsDataList ?? []).where((student) {
        return student.studentName!
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            student.enrollmentNo!.toUpperCase().contains(query.toUpperCase());
      }).toList();
    });
  }

  void sortStudents() {
    setState(() {
      filteredStudentsDataList?.sort((a, b) {
        int comparison = a.startDate!.compareTo(b.startDate!);
        return isAscending ? comparison : -comparison;
      });
      isAscending = !isAscending;
    });
  }

  bool isHOD() => facDesignation.toLowerCase() == "hod";

  List<EngagedStudent> filterStudents(String filter) {
    DateTime today = DateTime.now();
    DateTime currentDate =
        DateTime(today.year, today.month, today.day); // Strip the time part

    if (filter == "ALL") {
      return List.from(filteredStudentsDataList ?? []);
    } else if (filter == "CURRENT") {
      return filteredStudentsDataList?.where((student) {
            DateTime endDate = DateTime(
              student.endDate!.year,
              student.endDate!.month,
              student.endDate!.day,
            );
            return endDate.isAfter(currentDate) ||
                endDate.isAtSameMomentAs(currentDate);
          }).toList() ??
          [];
    } else if (filter == "PAST") {
      return filteredStudentsDataList?.where((student) {
            DateTime endDate = DateTime(
              student.endDate!.year,
              student.endDate!.month,
              student.endDate!.day,
            );
            return endDate.isBefore(currentDate);
          }).toList() ??
          [];
    } else if (filter == "BY ME") {
      return filteredStudentsDataList?.where((student) {
            return student.facultyInfoId == facId;
          }).toList() ??
          [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Student Engage"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.offAllNamed("/dashboard");
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: muColor,
          labelColor: backgroundColor,
          labelStyle: TextStyle(
              fontFamily: 'mu_reg', fontSize: 20, fontWeight: FontWeight.bold),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 5,
          unselectedLabelColor: Colors.black26,
          unselectedLabelStyle: TextStyle(
              fontFamily: 'mu_reg', fontSize: 15, fontWeight: FontWeight.bold),
          tabs: isHOD()
              ? [
                  Tab(text: "ALL"),
                  Tab(text: "CURRENT"),
                  Tab(text: "PAST"),
                  Tab(text: "BY ME"),
                ]
              : [
                  Tab(text: "ALL"),
                  Tab(text: "CURRENT"),
                  Tab(text: "PAST"),
                ],
          indicatorColor: Colors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: muColor,
        child: HugeIcon(
            icon: HugeIcons.strokeRoundedUserAdd01, color: backgroundColor),
        onPressed: () => Get.toNamed("/addEngagedStudent",
            arguments: {'faculty_id': facId, 'faculty_des': facDesignation}),
      ),
      body: isLoading
          ? AdaptiveLoadingScreen()
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          cursorColor: muColor,
                          decoration: InputDecoration(
                            labelText: 'Name / Enrollment',
                            labelStyle: TextStyle(
                              fontFamily: "mu_reg",
                              color: muGrey2,
                            ),
                            prefixIcon: HugeIcon(
                              icon: HugeIcons.strokeRoundedUserSearch01,
                              color: muGrey2,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedSearchRemove,
                                        color: muColor),
                                    onPressed: () {
                                      searchController.clear();
                                      filterStudentsBySearch(
                                          ''); // Reset search results
                                    },
                                  )
                                : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: muGrey2),
                              borderRadius: BorderRadius.circular(borderRad),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: muGrey2),
                              borderRadius: BorderRadius.circular(borderRad),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: getSize(context, 2.5),
                            fontFamily: "mu_reg",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: HugeIcon(
                          icon: isAscending
                              ? HugeIcons.strokeRoundedSortByUp01
                              : HugeIcons.strokeRoundedSortByDown01,
                          color: muColor,
                        ),
                        onPressed: sortStudents,
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: isHOD()
                          ? [
                              buildStudentList(filterStudents("ALL")),
                              buildStudentList(filterStudents("CURRENT")),
                              buildStudentList(filterStudents("PAST")),
                              buildStudentList(filterStudents("BY ME")),
                            ]
                          : [
                              buildStudentList(filterStudents("ALL")),
                              buildStudentList(filterStudents("CURRENT")),
                              buildStudentList(filterStudents("PAST")),
                            ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildStudentList(List<EngagedStudent> students) {
    return RefreshIndicator.adaptive(
      color: muColor,
      backgroundColor: backgroundColor,
      onRefresh: fetchEngagedStudentDetail,
      child: students.isEmpty
          ? DataNotFound()
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: muGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedUser,
                                  color: muColor,
                                  size: 20),
                            ),
                            Text("${student.studentName}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedIdentityCard,
                                  color: muColor,
                                  size: 20),
                            ),
                            Text("${student.enrollmentNo}",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 8),
                        student.startDate == student.endDate
                            ? Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: HugeIcon(
                                        icon: HugeIcons.strokeRoundedCalendar02,
                                        color: muColor,
                                        size: 20),
                                  ),
                                  Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(student.startDate!),
                                      style: TextStyle(fontSize: 14)),
                                ],
                              )
                            : Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: HugeIcon(
                                        icon: HugeIcons.strokeRoundedCalendar02,
                                        color: muColor,
                                        size: 20),
                                  ),
                                  Text(
                                      "${DateFormat('dd-MM-yyyy').format(student.startDate!)}  to  ${DateFormat('dd-MM-yyyy').format(student.endDate!)}",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                        SizedBox(height: 8),
                        isHOD()
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedCheckmarkBadge03,
                                        color: muColor,
                                        size: 20),
                                  ),
                                  Text("${student.facultyName}",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
