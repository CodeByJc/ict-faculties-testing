import 'package:flutter/material.dart';
import 'package:ict_faculties/Helper/Colors.dart';
import 'package:ict_faculties/Helper/Components.dart';
import 'package:ict_faculties/Helper/images_path.dart';

class IctLogo extends StatelessWidget {
  const IctLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context, 0.85),
      height: getHeight(context, 0.12),
      child: Stack(
        children: [
          Image.asset(
            ICTLogo,
            scale: 1.5,
          ),
          Positioned(
              left: getSize(context, 8.5),
              top: getSize(context, 4),
              child: Text("Information &",style: TextStyle(fontWeight: FontWeight.bold, fontSize: getSize(context, 3)))),
          Positioned(
              left: getSize(context, 9),
              top: getSize(context, 7),
              child: Text("Communication Technology",style: TextStyle(color: muColor,fontWeight: FontWeight.bold, fontSize: getSize(context, 2.5)))),
        ],
      ),
    );
  }
}
