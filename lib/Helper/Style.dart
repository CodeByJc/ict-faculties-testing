import 'package:flutter/material.dart';
import 'package:ict_faculties/Helper/Components.dart';

TextStyle appbarStyle(context) {
  return TextStyle(
    color: Colors.white,
    fontFamily: 'mu_reg',
    fontSize: getSize(context, 2.5),
  );
}
TextStyle AppbarStyle = TextStyle(color: Colors.white,fontFamily: "mu_reg",fontSize: 20,);

TextStyle tagStyle(Color color,double fsize,bool isBold) {
  return TextStyle(color: color,fontFamily: isBold?"mu_bold":"mu_reg",fontSize: fsize);
}