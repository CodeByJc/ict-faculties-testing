import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:ict_faculties/Binding/extra_mark_attendance_binding.dart';
import 'package:ict_faculties/Binding/feedback_bindings.dart';
import 'package:ict_faculties/Binding/punch_bindings.dart';
import 'package:ict_faculties/Binding/reg_attendance_schedule_binding.dart';
import 'package:ict_faculties/Binding/reg_mark_attendance_binding.dart';
import 'package:ict_faculties/Binding/splash_binding.dart';
import 'package:ict_faculties/Helper/Colors.dart';
import 'package:ict_faculties/Screens/Attendance/Extra/extra_mark_attendance.dart';
import 'package:ict_faculties/Screens/Attendance/Faculty/punch_screen.dart';
import 'package:ict_faculties/Screens/Authentication/change_password.dart';
import 'package:ict_faculties/Screens/Exception/no_schedule_available.dart';
import 'package:ict_faculties/Screens/Exception/service_not_available.dart';
import 'package:ict_faculties/Screens/Feedback/feedback.dart';
import 'package:ict_faculties/Screens/Announcement/announcement.dart';
import 'package:ict_faculties/Screens/Announcement/announcement_add.dart';
import 'package:ict_faculties/Screens/Announcement/announcement_delete.dart';
import 'package:ict_faculties/Binding/announcement_binding.dart';
import 'package:ict_faculties/Screens/StudentEngage/engage_students_list.dart';
import 'package:ict_faculties/Screens/StudentSearch/search.dart';
import 'Binding/attendance_show_binding.dart';
import 'Binding/change_password_binding.dart';
import 'Binding/extra_attendance_schedule_binding.dart';
import 'Binding/student_details_binding.dart';
import 'Binding/student_rounds_binding.dart';
import 'Screens/Attendance/Extra/extra_attendance_schedule.dart';
import 'Screens/Attendance/Regular/reg_mark_attendance.dart';
import 'Screens/Attendance/Regular/reg_attendance_schedule.dart';
import 'Screens/Attendance/StudentTotal/attendance_show.dart';
import 'Screens/Home/home_dashboard.dart';
import 'Screens/Authentication/forgot_password.dart';
import 'Screens/Authentication/login.dart';
import 'Screens/Placements/student_placement_screen.dart';
import 'Screens/Profile/profile.dart';
import 'Screens/Splash/main_splash.dart';
import 'Screens/StudentEngage/add_engage_student.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: muColor,
            selectionColor: muColor50,
            selectionHandleColor: muColor),
        colorScheme: ColorScheme.light(primary: muColor),
        dividerColor: Colors.grey,
        fontFamily: "mu_reg",
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: muColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontFamily: "mu_reg", color: backgroundColor, fontSize: 20),
        ),
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: "/splashscreen",
            transition: Transition.fadeIn,
            binding: SplashBinding(),
            page: () => SplashScreen()),
        GetPage(
            name: "/login",
            transition: Transition.fadeIn,
            page: () => const LoginScreen()),
        GetPage(
            name: "/forgotPass",
            transition: Transition.fadeIn,
            page: () => const ForgotPasswordScreen()),
        GetPage(
            name: "/dashboard",
            transition: Transition.fadeIn,
            page: () => const DashboardScreen()),
        GetPage(
            name: "/engagedStudent",
            transition: Transition.fadeIn,
            page: () => const EngagedStudentScreen()),
        GetPage(
            name: "/addEngagedStudent",
            transition: Transition.fadeIn,
            page: () => const Addstudentengaged()),
        GetPage(
            name: "/regAttendanceSchedule",
            transition: Transition.fadeIn,
            binding: RegAttendanceScheduleBinding(),
            page: () => const RegAttendanceSchedule()),
        GetPage(
            name: "/markARegAttendance",
            transition: Transition.fadeIn,
            binding: RegMarkAttendanceBinding(),
            page: () => const RegMarkAttendance()),
        GetPage(
            name: "/extraAttendanceSchedule",
            transition: Transition.fadeIn,
            binding: ExtraAttendanceScheduleBinding(),
            page: () => const ExtraAttendanceSchedule()),
        GetPage(
            name: "/markExtraAttendance",
            transition: Transition.fadeIn,
            binding: ExtraMarkAttendanceBinding(),
            page: () => const MarkExtraAttendance()),
        GetPage(
            name: "/test",
            transition: Transition.fadeIn,
            page: () => const NoScheduleAvailable()),
        GetPage(
            name: "/serverFailed",
            transition: Transition.fadeIn,
            page: () => const ServiceNotAvailable()),
        GetPage(
            name: "/profile",
            transition: Transition.fadeIn,
            page: () => const ProfilePage()),
        GetPage(
            name: "/changePassword",
            transition: Transition.fadeIn,
            binding: ChangePasswordBinding(),
            page: () => const ChangePasswordScreen()),
        GetPage(
            name: "/punchScreen",
            transition: Transition.fadeIn,
            binding: PunchBindings(),
            page: () => const PunchScreen()),
        GetPage(
            name: "/feedback",
            transition: Transition.fadeIn,
            binding: FeedbackBinding(),
            page: () => const FeedbackScreen()),
        GetPage(
            name: "/student-search",
            transition: Transition.fadeIn,
            binding: StudentDetailsBinding(),
            page: () => const StudentSearchScreen()),
        GetPage(
            name: "/student-totalAttendance",
            transition: Transition.fadeIn,
            binding: AttendanceShowBinding(),
            page: () => const StudentAttendanceScreen()),
        GetPage(
            name: "/student-placementRounds",
            transition: Transition.fadeIn,
            binding: StudentRoundsBinding(),
            page: () => const StudentRoundsScreen()),
        GetPage(
            name: "/Announcement",
            transition: Transition.fadeIn,
            binding: AnnouncementBinding(),
            page: () => const AnnouncementScreen()),
        GetPage(
            name: "/addAnnouncement",
            transition: Transition.fadeIn,
            binding: AnnouncementBinding(),
            page: () => const AnnouncementAddScreen(facultyId: 1)),
        GetPage(
            name: "/deleteAnnouncement",
            transition: Transition.fadeIn,
            binding: AnnouncementBinding(),

            page: () => AnnouncementDeleteScreen(facultyId: 1)),

      ],
      initialRoute: "/splashscreen",
    );
  }
}
