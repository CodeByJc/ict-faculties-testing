// ignore_for_file: use_build_context_synchronously

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/attendance_controller.dart';
import 'package:ict_faculties/Controllers/student_engaged_controller.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Models/student.dart';
import 'package:ict_faculties/Screens/StudentEngage/engage_students_list.dart';
import 'package:intl/intl.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';
import '../Loading/adaptive_loading_screen.dart';

class Addstudentengaged extends StatefulWidget {
  const Addstudentengaged({super.key});

  @override
  State<Addstudentengaged> createState() => _AddstudentengagedState();
}

class _AddstudentengagedState extends State<Addstudentengaged> {
  late int facId;
  late String facDesignation;
  bool isLoading = true;
  List<Student>? studentsDataList; // Change the type to CCStudent
  final StudentController studentController = Get.put(StudentController());
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  TextEditingController searchController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  EngagedStudentScreen obj = EngagedStudentScreen();
  Student? foundStudent;

  @override
  void initState() {
    facId = Get.arguments['faculty_id'];
    facDesignation = Get.arguments['faculty_des'];
    super.initState();
    fetchStudentDetail();
  }

  Future<void> fetchStudentDetail() async {
    setState(() {
      isLoading = true;
    });
    List<Student>? fetchedStudentDataList =
        await studentController.getStudentsByCC(facId);
    if (!mounted) return;

    // Map the fetched data to CCStudent
    setState(() {
      studentsDataList = fetchedStudentDataList;
      isLoading = false;
    });
  }

  void searchStudent() {
    setState(() {
      foundStudent = null;
    });
    String searchText = searchController.text.trim();
    if (studentsDataList != null && searchText.isNotEmpty) {
      foundStudent = studentsDataList?.firstWhere(
        (student) =>
            student.enrollmentNo == searchText || student.grNo == searchText,
      );
    } else {
      foundStudent = null;
    }
    setState(() {});
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller,
      {bool isEndDate = false}) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now();

    if (isEndDate) {
      // Ensure the start date is valid before using it
      if (startDateController.text.isNotEmpty) {
        try {
          firstDate = DateFormat('dd-MM-yyyy').parse(startDateController.text);
          initialDate = firstDate; // Default the end date to the start date
        } catch (e) {
          // Log or handle parsing errors if needed
        }
      }
    }

      DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: muColor, // (deprecated, but harmless)
            colorScheme: ColorScheme.light(
              primary: muColor, // Header & active dates
              onPrimary: Colors.white, // Header text color
              onSurface: muColor, // Default text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    // ✅ Null check before formatting
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      controller.text = formattedDate;
    }
    }

  Future<void> upsertEngaged() async {
    if (foundStudent != null && startDateController.text.isNotEmpty) {
      try {
        // Parse the start date
        DateTime startDate =
            DateFormat('dd-MM-yyyy').parse(startDateController.text);

        DateTime endDate = endDateController.text.isEmpty
            ? startDate
            : DateFormat('dd-MM-yyyy').parse(endDateController.text);

        // Call the upsertEngagedStudent method
        bool isSuccess = await attendanceController.upsertEngagedStudent(
          foundStudent?.id,
          facId,
          "N/A",
          "oe",
          DateFormat('yyyy-MM-dd').format(startDate),
          DateFormat('yyyy-MM-dd').format(endDate),
        );

        if (isSuccess) {
          ArtSweetAlert.show(
            context: context,
            barrierDismissible: false,
            artDialogArgs: ArtDialogArgs(
              dialogPadding: EdgeInsets.only(top: 30),
              type: ArtSweetAlertType.success,
              sizeSuccessIcon: 70,
              confirmButtonText: "",
              confirmButtonColor: Colors.white,
              title: "Student engaged successful!",
              dialogDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          );
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back();
            Get.toNamed(
              "/engagedStudent",
              arguments: {'faculty_id': facId, 'faculty_des': facDesignation},
            );
          });
        } else {
          ArtSweetAlert.show(
            context: context,
            barrierDismissible: false,
            artDialogArgs: ArtDialogArgs(
              dialogPadding: EdgeInsets.only(top: 30),
              type: ArtSweetAlertType.danger,
              sizeSuccessIcon: 70,
              confirmButtonText: "",
              confirmButtonColor: Colors.white,
              title: "Failed to engage student!",
              dialogDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          );
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back();
          });
        }
      } catch (e) {
        ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
            dialogPadding: EdgeInsets.only(top: 30),
            type: ArtSweetAlertType.danger,
            sizeSuccessIcon: 70,
            confirmButtonText: "",
            confirmButtonColor: Colors.white,
            title: "Invalid date format!",
            dialogDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Student Engage"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Light1),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (foundStudent != null && startDateController.text != "") {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.question,
                sizeSuccessIcon: 70,
                confirmButtonText: "CONFIRM", // Hides the confirm button
                confirmButtonColor: muColor,
                onConfirm: () async {
                  upsertEngaged();
                  Get.back();
                },
                text:
                    "${foundStudent?.firstName} ${foundStudent?.lastName} \n is officially engaged at \n"
                    "${startDateController.text == endDateController.text || endDateController.text.isEmpty ? startDateController.text : "${startDateController.text} \n to \n ${endDateController.text}"}",
                dialogDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          } else {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.warning,
                sizeSuccessIcon: 70,
                confirmButtonText: "OK", // Hides the confirm button
                confirmButtonColor: muColor,
                onConfirm: () async {
                  Get.back();
                },
                title: "Required Field Missing",
                dialogDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          }
        },
        backgroundColor: muColor,
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedUploadSquare01,
          color: Colors.white,
        ),
        label: Text(
          "SUBMIT",
          style: TextStyle(fontFamily: 'mu_bold', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: isLoading
            ? AdaptiveLoadingScreen()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: getHeight(context, 0.07),
                        width: getWidth(context, 0.7),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: searchController,
                          cursorColor: muColor,
                          decoration: InputDecoration(
                            labelText: 'GR / Enrollment',
                            labelStyle: TextStyle(
                              fontFamily: "mu_reg",
                              color: Colors.grey,
                            ),
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
                      InkWell(
                        onTap: () => searchStudent(),
                        child: Container(
                          width: getWidth(context, 0.2),
                          height: getHeight(context, 0.065),
                          decoration: BoxDecoration(
                              color: muColor,
                              borderRadius: BorderRadius.circular(borderRad)),
                          child: Center(
                              child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedUserAdd01,
                                  color: backgroundColor)),
                        ),
                      )
                    ],
                  ),
                  // Student Details
                  if (foundStudent != null)
                    Column(
                      children: [
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: muGrey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: getWidth(context, 1),
                            height: getHeight(context, 0.12),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: SizedBox(
                                width: getWidth(context, 0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 0),
                                          child: HugeIcon(
                                            icon: HugeIcons.strokeRoundedUser,
                                            color: muColor,
                                            size: 20,
                                          ),
                                        ),
                                        Text(
                                          "${foundStudent?.firstName} ${foundStudent?.lastName}",
                                          style: TextStyle(
                                              fontFamily: 'mu_bold',
                                              fontSize: getSize(context, 2.5)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 0),
                                          child: HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedIdentityCard,
                                            color: muColor,
                                            size: 20,
                                          ),
                                        ),
                                        Text(
                                          "${foundStudent?.enrollmentNo}",
                                          style: TextStyle(
                                              fontFamily: 'mu_reg',
                                              fontSize: getSize(context, 2)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 0),
                                          child: HugeIcon(
                                            icon: HugeIcons.strokeRoundedId,
                                            color: muColor,
                                            size: 20,
                                          ),
                                        ),
                                        Text(
                                          "${foundStudent?.grNo}",
                                          style: TextStyle(
                                              fontFamily: 'mu_reg',
                                              fontSize: getSize(context, 2)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (!isLoading && searchController.text.isNotEmpty)
                    Column(
                      children: [
                        Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                        Center(
                          child: Text(
                            "No student found with this GR No. / Enrollment No.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  // Date Pickers for Start and End Date
                  Container(
                    height: getHeight(context, 0.07),
                    width: getWidth(context, 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRad),
                      border: Border.all(color: muGrey2),
                    ),
                    child: InkWell(
                      onTap: () => selectDate(context, startDateController),
                      child: TextField(
                        controller: startDateController,
                        cursorColor: muColor,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'Start Date',
                          labelStyle: const TextStyle(
                            fontFamily: "mu_reg",
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Light1, width: 1),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Light1, width: 1),
                            borderRadius: BorderRadius.circular(borderRad),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: getSize(context, 2.5),
                            fontFamily: "mu_reg",
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        readOnly: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: getHeight(context, 0.07),
                    width: getWidth(context, 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRad),
                      border: Border.all(color: muGrey2),
                    ),
                    child: InkWell(
                      onTap: () => selectDate(context, endDateController,
                          isEndDate: true),
                      child: TextField(
                        controller: endDateController,
                        cursorColor: muColor,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'End Date',
                          labelStyle: const TextStyle(
                            fontFamily: "mu_reg",
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: muGrey2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: muGrey2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: getSize(context, 2.5),
                            fontFamily: "mu_reg",
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
