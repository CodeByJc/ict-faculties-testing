import 'package:flutter/material.dart';
import 'package:ict_faculties/Helper/Colors.dart';
import 'package:ict_faculties/Helper/Components.dart';

import '../../Helper/images_path.dart';

class ServiceNotAvailable extends StatelessWidget {
  const ServiceNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            color: backgroundColor,
            child: SizedBox(
              height: getHeight(context, 0.7),
              child: Expanded(child: SizedBox(
                height: getHeight(context, 1),
                width: getWidth(context, 1),
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            NoScheduleAvailabeIMG,
                            height: 125,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "No Schedule For Today",
                          style: TextStyle(
                              fontFamily: "mu_reg",
                              fontSize: 18,
                              color: Light2,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ),
          )
        ]);
  }
}
