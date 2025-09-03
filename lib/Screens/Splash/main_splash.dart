import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ict_faculties/Controllers/splash_controller.dart';
import 'package:ict_faculties/Helper/Colors.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Helper/images_path.dart';
import 'package:ict_faculties/Network/API.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  // GetStorage instance
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: getHeight(context, 0.9),
            width: getWidth(context, 1),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image(
                  image: AssetImage(MuLogo),
                  height: getHeight(context, 0.13),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Version $CurrentVersion",
                style: TextStyle(
                    fontSize: getSize(context, 2), fontFamily: "mu_reg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
