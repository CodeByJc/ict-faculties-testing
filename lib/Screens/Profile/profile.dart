import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Models/faculty.dart';
import 'package:ict_faculties/Widgets/detail_with_heading.dart';
import '../../Helper/Colors.dart';
import '../../Helper/images_path.dart';
import '../../Helper/size.dart';
import '../../Network/API.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Faculty userData = Get.arguments;
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

  onLogout() {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.question,
        sizeSuccessIcon: 70,
        showCancelBtn: true,
        confirmButtonText: "Yes",
        confirmButtonColor: muColor,
        cancelButtonColor: Colors.redAccent,
        cancelButtonText: "No",
        onConfirm: () async {
          final box = GetStorage();
          await CachedNetworkImage.evictFromCache(
              facultyImageAPI(userData.facultyId));
          await box.write('loggedin', false);
          await box.write('userdata', null);
          Get.offNamed('/login');
        },
        title: "Are you sure to Logout?",
        dialogDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
              onPressed: () => Get.back()),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => onLogout(),
                child: Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(borderRad)),
                    child: Center(
                        child: Text(
                      "Logout",
                      style: TextStyle(
                          color: backgroundColor, fontWeight: FontWeight.bold),
                    ))),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  height: getHeight(context, 0.2),
                  width: getWidth(context, 1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRad),
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage(MuMainBuilding),
                          opacity: 0.3,
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: muGrey2,
                          border: Border.all(
                              color: muGrey2,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside)),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        imageUrl: facultyImageAPI(userData.facultyId),
                        placeholder: (context, url) => HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          color: muColor,
                          size: 40,
                        ),
                        errorWidget: (context, url, error) => HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          color: muColor,
                          size: 40,
                        ),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              DetailWithHeading(
                  HeadingName: "Name",
                  Details: "${userData.firstName} ${userData.lastName}"),
              SizedBox(
                height: 10,
              ),
              DetailWithHeading(
                  HeadingName: "Designation", Details: _getDesignation()),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                      child: DetailWithHeading(
                          HeadingName: "User ID", Details: userData.facultyId)),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: DetailWithHeading(
                          HeadingName: "Joining Date",
                          Details: userData.joiningDate.isNotEmpty?DateFormat('dd-MM-yyyy').format(DateTime.parse(userData.joiningDate)):""
                      ),)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DetailWithHeading(
                  HeadingName: "Mobile no.", Details: userData.phoneNo),
              SizedBox(
                height: 10,
              ),
              DetailWithHeading(
                  HeadingName: "Email Id", Details: userData.email),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => Get.toNamed("/changePassword",arguments: userData),
                child: Container(
                  height: getHeight(context, 0.06),
                  decoration: BoxDecoration(
                      color: muGrey,
                      border: Border.all(color: muGrey2),
                      borderRadius: BorderRadius.circular(borderRad)),
                  child: Center(child: Text("Change Password",style: TextStyle(color: muColor,fontSize: 20),)),
                ),
              )
            ],
          ),
        ));
  }
}
