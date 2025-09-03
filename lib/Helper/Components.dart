import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Helper/colors.dart';

import 'Style.dart';

double getHeight(context, double i) {
  double result = MediaQuery.of(context).size.height * i;
  return result;
}

double getWidth(context, double i) {
  double result = MediaQuery.of(context).size.width * i;
  return result;
}

double getSize(context, double i) {
  double result = MediaQuery.of(context).size.width * i / 50;
  return result;
}

Widget horizontalLine() {
  return const SizedBox(
    height: 1.5,
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Color.fromARGB(40, 0, 0, 0),
      ),
    ),
  );
}

Widget BlackTag(context, Color? color, String? Line1, String? Line2,
    Widget? imageWidget, bool isReverse, String onTapPath, arg) {
  return Container(
    alignment: Alignment.centerRight,
    child: InkWell(
      onTap: () => Get.toNamed(onTapPath, arguments: arg),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Conditional alignment
        children: isReverse
            ? [
                Container(
                  height: 65,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(500),
                    ),
                  ),
                ),
                Container(
                  height: 65,
                  width: 300,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(500),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 55,
                          width: 55,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: muGrey2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(500))),
                          child: imageWidget,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: getWidth(context, 0.5),
                              child: Text(
                                Line1 ?? "Loading...",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: tagStyle(Colors.white, 18, true),
                              ),
                            ),
                            Text(
                              Line2 ?? "Loading...",
                              overflow: TextOverflow.ellipsis,
                              style: tagStyle(Light2, 15, false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : [
                Container(
                  height: 65,
                  width: 300,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(500),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                Line1 ?? "Loading...",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: tagStyle(Colors.white, 18, true),
                              ),
                            ),
                            Text(
                              Line2 ?? "Loading...",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: tagStyle(Light2, 15, false),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 55,
                          width: 55,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: muGrey2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(500))),
                          child: imageWidget,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 65,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color ?? Colors.black,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(500),
                    ),
                  ),
                ),
              ],
      ),
    ),
  );
}

Widget TapIcons(
  context,
  String name,
  double nameSize,
  IconData iconData,
  double iconSize,
  String route,
  routeArg,
) {
  return InkWell(
    onTap: () => Get.toNamed(route, arguments: routeArg),
    child: Column(
      children: [
        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: muGrey,
            borderRadius: BorderRadius.circular(15), // rounded corners
          ),
          child: Center(
            child: HugeIcon(
              icon: iconData,
              color: Colors.black,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(
          height: getHeight(context, 0.01),
        ),
        SizedBox(
            height: getHeight(context, 0.05),
            width: getWidth(context, 0.25),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'mu_reg',
                  color: muColor,
                  height: 1,
                  fontSize: getSize(context, nameSize)),
              // softWrap: true,
              textAlign: TextAlign.center,
            ))
      ],
    ),
  );
}

Widget Heading1(context, String str, double size, double leftPad) {
  return Padding(
    padding: EdgeInsets.only(top: 8.0, bottom: 4, left: leftPad),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            height: getSize(context, size * 1.5),
            width: getSize(context, size * 0.35),
            decoration: BoxDecoration(
                color: muColor, borderRadius: BorderRadius.circular(500)),
          ),
        ),
        Container(
          child: Text(
            str,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "mu_bold",
              fontSize: getSize(context, size),
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    ),
  );
}

radialIndicator(BuildContext context, double input) {
  return Stack(
    alignment: Alignment.center,
    children: [
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: input),
        duration: const Duration(seconds: 1),
        curve: Easing.linear,
        builder: (context, value, child) {
          return Center(
            child: Text(
              '${value.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize:
                value < 100 ? getSize(context, 3.5) : getSize(context, 3),
                fontFamily: "mu_bold",
                color: muColor,
              ),
            ),
          );
        },
      ),
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: input / 100),
        duration: const Duration(seconds: 1),
        curve: Easing.linear,
        builder: (context, value, child) {
          return SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: muGrey2,
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(muColor),
            ),
          );
        },
      ),
    ],
  );
}
