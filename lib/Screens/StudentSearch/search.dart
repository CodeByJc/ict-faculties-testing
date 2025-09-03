import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/student_details_controller.dart';
import 'package:ict_faculties/Helper/Style.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/Colors.dart';
import '../../Helper/Components.dart';
import '../../Helper/size.dart';
import 'package:intl/intl.dart';
import '../../Network/API.dart';
import '../../Widgets/dashboard_icon.dart';
import '../Loading/adaptive_loading_screen.dart';

class StudentSearchScreen extends GetView<StudentDetailsController> {
  const StudentSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final TextEditingController searchController = TextEditingController();
    final RxBool isImageLoading = false.obs;

    // Load student image
    Future<void> loadStudentImage(String grNo) async {
      isImageLoading.value = true;
      try {
        // Simulate API call (replace with actual studentImageAPI logic)
        await Future.delayed(Duration(seconds: 1)); // Mock delay
        // Image URL is fetched via studentImageAPI(grNo)
      } catch (e) {
        print('Error loading student image: $e');
      } finally {
        isImageLoading.value = false;
      }
    }

    // Show SweetAlert with Call and WhatsApp options
    Future<void> showContactOptions(String phoneNumber) async {
      if (phoneNumber.isEmpty || phoneNumber.length != 10) {
        Get.snackbar(
          'Error',
          'Invalid phone number',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          title: 'Contact Options',
          text: 'Choose an action for $phoneNumber',
          confirmButtonText: 'Call',
          showCancelBtn: true,
          confirmButtonColor: muColor,
          cancelButtonText: 'WhatsApp',
          cancelButtonColor: Colors.green,
          type: ArtSweetAlertType.question,
          onConfirm: () async {
            final url = 'tel:$phoneNumber';
            try{
              await launchUrl(Uri.parse(url));
            } catch(e){
              Get.snackbar(
                'Error',
                'Could not open dialer',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          onCancel: () async {
            final url = 'https://wa.me/+91$phoneNumber';
            try{
              await launchUrl(Uri.parse(url));
            }catch(e){
              Get.snackbar(
                'Error',
                'Could not open WhatsApp',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Search",
          style: AppbarStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField and Button
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
                      suffixIcon: IconButton(
                        icon: Icon(HugeIcons.strokeRoundedCancel01, color: muColor),
                        onPressed: () {
                          searchController.clear();
                          controller.student.value = null;
                          focusNode.requestFocus();
                        },
                      ),
                    ),
                    style: TextStyle(
                      fontSize: getSize(context, 2.5),
                      fontFamily: "mu_reg",
                      fontWeight: FontWeight.w500,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.searchStudent(value.trim());
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter an enrollment or GR number',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (searchController.text.trim().isNotEmpty) {
                      controller.searchStudent(searchController.text.trim());
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please enter an enrollment or GR number',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Container(
                    width: getWidth(context, 0.2),
                    height: getHeight(context, 0.065),
                    decoration: BoxDecoration(
                      color: muColor,
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Loading Screen or Student Details
            Obx(
                  () => controller.isSearchingStudent.value
                  ? const AdaptiveLoadingScreen()
                  : controller.student.value == null
                  ? Center(
                child: Text(
                  'Enter valid enrollment or GR',
                  style: TextStyle(
                    fontSize: getSize(context, 2),
                    color: muGrey2,
                  ),
                ),
              )
                  : Column(
                    children: [
                      Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                      color: muGrey,
                      borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Obx(
                                () => isImageLoading.value
                                ? SizedBox(
                              width: 120,
                              height: 160,
                              child: AdaptiveLoadingScreen(),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                studentImageAPI(controller.student.value!.grNo),
                                width: 120,
                                height: 160,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    width: 120,
                                    height: 160,
                                    child: AdaptiveLoadingScreen(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 160,
                                    color: muGrey,
                                    child: Center(
                                      child: Text(
                                        'Image\nNot Found',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: getSize(context, 1.8),
                                          color: muGrey2,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDataRow(
                          context,
                          title: 'Name',
                          value: controller.student.value!.studentName,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Enrollment',
                          value: controller.student.value!.enrollmentNo,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'GR No.',
                          value: controller.student.value!.grNo,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Email',
                          value: controller.student.value!.studentEmail,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Phone',
                          value: controller.student.value!.studentPhone,
                          isPhone: true,
                          onTap: () => showContactOptions(controller.student.value!.studentPhone),
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Class',
                          value: '${controller.student.value!.classname} (${controller.student.value!.classbatch})',
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Semester',
                          value: controller.student.value!.sem.toString(),
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Program',
                          value: controller.student.value!.eduType,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Batch',
                          value: "${controller.student.value!.batchStartYear} - ${controller.student.value!.batchEndYear}",
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Birth Date',
                          value: controller.student.value!.birthdate.isNotEmpty?DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.student.value!.birthdate)):"",
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Parent Name',
                          value: controller.student.value!.parentName,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Profession',
                          value: controller.student.value!.profession,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Parent Phone',
                          value: controller.student.value!.parentPhone,
                          isPhone: true,
                          onTap: () => showContactOptions(controller.student.value!.parentPhone),
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Address',
                          value: controller.student.value!.address,
                        ),
                        const SizedBox(height: 10),
                        _buildDataRow(
                          context,
                          title: 'Placement Support',
                          value: controller.student.value!.placementSupport,
                        ),
                      ],
                                      ),
                                    ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (controller.student.value!.placementSupport == "Yes")TapIcon2(
                              name: "Placement info",
                              iconData: HugeIcons.strokeRoundedUniversity,
                              route: "/student-placementRounds",
                              routeArg: {
                                'student_id': controller.student.value!.studentId,
                                'student_name': controller.student.value!.studentName,
                                'batch_id': controller.student.value!.batchId
                              },
                            ),
                            TapIcon2(
                                name: "Attendance",
                                iconData: HugeIcons.strokeRoundedBuilding05,
                                route: "/student-totalAttendance",
                              routeArg: {
                                'student_id': controller.student.value!.studentId,
                                'student_name': controller.student.value!.studentName,
                                'batch_id': controller.student.value!.batchId
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build data row with bold, colored title and regular value
  Widget _buildDataRow(
      BuildContext context, {
        required String title,
        required String value,
        bool isPhone = false,
        VoidCallback? onTap,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: getWidth(context, 0.25), // Fixed width for title alignment
          child: Text(
            title,
            style: TextStyle(
              fontSize: getSize(context, 2),
              fontWeight: FontWeight.bold,
              color: muColor,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: isPhone ? onTap : null,
            child: Text(
              ": $value",
              style: TextStyle(
                fontSize: getSize(context, 2),
                fontFamily: 'mu_reg',
                color: isPhone ? muColor : null, // Highlight phone numbers
                decoration: isPhone ? TextDecoration.underline : null, // Underline for clickable
              ),
            ),
          ),
        ),
      ],
    );
  }
}