import 'package:flutter/material.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Helper/size.dart';

class DetailWithHeading extends StatelessWidget {
  final String HeadingName;
  final dynamic Details;

  const DetailWithHeading({
    super.key,
    required this.HeadingName,
    required this.Details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: muGrey2),
        borderRadius: BorderRadius.circular(borderRad),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Container(
                width: 2,
                height: 45,
                decoration: BoxDecoration(
                  color: muColor,
                  borderRadius: BorderRadius.circular(borderRad),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HeadingName,
                    style: TextStyle(
                      color: muColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Details.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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
}