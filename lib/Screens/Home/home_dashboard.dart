import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Models/faculty.dart';
import 'package:ict_faculties/Network/API.dart';
import '../../Helper/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final box = GetStorage();
  late Faculty userData;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> storedData = box.read('userdata');
    userData = Faculty.fromJson(storedData);
  }

  _getDesignation() {
    if (userData.designation == 'tp') {
      return "Trainee Professor";
    } else if (userData.designation == 'ap') {
      return "Assistant Professor";
    } else if (userData.designation == 'hod') {
      return "HOD";
    } else if (userData.designation == 'la') {
      return "Lab Assistant";
    } else {
      return userData.designation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard",
            style: TextStyle(
                color: Colors.black, fontFamily: "mu_reg", fontSize: 23)),
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlackTag(
                context,
                Dark1,
                "${userData.firstName} ${userData.lastName}",
                "ID: ${userData.facultyId}  -  ${_getDesignation()}",
                CachedNetworkImage(
                  imageUrl: facultyImageAPI(userData.facultyId),
                  placeholder: (context, url) => HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 30,
                    color: Colors.black,
                  ),
                  errorWidget: (context, url, error) => HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 30,
                    color: Colors.black,
                  ),
                  fit: BoxFit.cover,
                ),
                false,
                '/profile',
                userData),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                // ✅ Removed fixed height (400) so GridView can size itself
                child: GridView.count(
                  shrinkWrap: true, // ✅ Let GridView take only needed space
                  physics:
                  NeverScrollableScrollPhysics(), // ✅ Prevents nested scroll issues
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio:
                  0.75, // ✅ Adjusted ratio to give more vertical room for text
                  padding: EdgeInsets.all(10),
                  children: [
                    TapIcons(context, "Punch", 2,
                        HugeIcons.strokeRoundedCalendarCheckIn01, 40,
                        "/punchScreen", {'faculty_id': userData.id}),
                    TapIcons(context, "Mark Attendance", 2,
                        HugeIcons.strokeRoundedCalendarUpload01, 40,
                        "/regAttendanceSchedule", {'faculty_id': userData.id}),
                    TapIcons(context, "Student Engaged", 2,
                        HugeIcons.strokeRoundedStudentCard, 40,
                        "/engagedStudent", {
                          'faculty_id': userData.id,
                          'faculty_des': userData.designation
                        }),
                    TapIcons(context, "Extra Attendance", 2,
                        HugeIcons.strokeRoundedGoogleSheet, 40,
                        "/extraAttendanceSchedule", {
                          'faculty_id': userData.id,
                          'faculty_des': userData.designation
                        }),
                    TapIcons(context, "Anonymous Feedback", 2,
                        HugeIcons.strokeRoundedBubbleChatSecure, 40,
                        "/feedback", {
                          'faculty_id': userData.id,
                          'faculty_des': userData.designation
                        }),
                    TapIcons(context, "Student Search", 2,
                        HugeIcons.strokeRoundedUserSearch01, 40,
                        "/student-search", null),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
