import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ict_faculties/Helper/Utils.dart';
import 'package:ict_faculties/Screens/Exception/service_not_available.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Helper/colors.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final controller = Get.find<InternetConnectivityController>();

  @override
  void onInit() {
    super.onInit();
    // checkVersion();
    _navigateAfterSplash();
  }

  _navigateAfterSplash() async {
    await Future.delayed(Duration(seconds: 1));
    bool isLoggedIn = box.read('loggedin') ?? false;
    if (isLoggedIn) {
      Get.offAllNamed("/dashboard");
    } else {
      Get.offAllNamed("/login");
    }
  }

  checkVersion() async {
    try {
      await controller.checkConnection();
      if (!controller.isConnected.value) {
        Utils()
            .showInternetAlert(context: Get.context!, onConfirm: checkVersion);
      } else {
        Map<String, String> body = {'login': 'faculty', 'code': CurrentVersion};
        final response = await http.post(
          Uri.parse(validateVersionAPI),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': validApiKey,
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          _navigateAfterSplash();
        } else {
          ArtSweetAlert.show(
            barrierDismissible: false,
            context: Get.context!,
            artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.warning,
              sizeSuccessIcon: 70,
              confirmButtonText: "Update Now", // Hides the confirm button
              confirmButtonColor: muColor,
              onConfirm: () async {
                String url = updateURL;
                await launch(url);
              },
              title: "App update available!",
              dialogDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }
      }
    } catch (e) {
      ServiceNotAvailable();
    }
  }
}
