import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';

class Utils {
  showInternetAlert(
      {required BuildContext context, required VoidCallback onConfirm}) {
    ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.warning,
        sizeSuccessIcon: 70,
        confirmButtonText: "Retry",
        confirmButtonColor: muColor,
        onConfirm: () {
          Get.back();
          onConfirm.call();
        },
        title: "No Internet Connection!",
        dialogDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  showSomethingWrongAlert(
      {required BuildContext context, required VoidCallback onConfirm}) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.warning,
        sizeSuccessIcon: 70,
        confirmButtonText: "Retry",
        confirmButtonColor: muColor,
        onConfirm: () {
          Get.back();
          onConfirm.call();
        },
        title: "Something Went Wrong !",
        dialogDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  showUploadSuccessAlert() {
    ArtSweetAlert.show(
      context: Get.context!,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        dialogPadding: EdgeInsets.only(top: 30),
        type: ArtSweetAlertType.success,
        sizeSuccessIcon: 70,
        confirmButtonText: "",
        confirmButtonColor: Colors.white,
        title: "Attendance Uploaded!",
        dialogDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      Get.back();
    });
  }

  showNoChangesUploadAlert() {
    ArtSweetAlert.show(
      context: Get.context!,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        dialogPadding: EdgeInsets.only(top: 30),
        type: ArtSweetAlertType.warning,
        sizeSuccessIcon: 70,
        confirmButtonText: "",
        confirmButtonColor: Colors.white,
        title: "No Changes in attendance!",
        dialogDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  showUploadFailedAlert() {
    ArtSweetAlert.show(
      context: Get.context!,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        dialogPadding: EdgeInsets.only(top: 30),
        type: ArtSweetAlertType.danger,
        sizeSuccessIcon: 70,
        confirmButtonText: "",
        confirmButtonColor: Colors.white,
        title: "Error uploading attendance!",
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
}
