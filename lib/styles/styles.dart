import 'package:flutter/material.dart';
import 'colors.dart';

class textDesigns {
  static const TextStyle basicPanelText = TextStyle(
      color: AppColors.defaultText, fontSize: 20, fontWeight: FontWeight.w300);
  static const TextStyle resizePanelText = TextStyle(
      color: Color.fromRGBO(26, 28, 35, 1),
      fontSize: 22,
      fontWeight: FontWeight.w800);
  static const TextStyle valueText = TextStyle(
      color: AppColors.defaultText, fontSize: 20, fontWeight: FontWeight.w800);
  static const TextStyle aspectText = TextStyle(
      color: AppColors.defaultText, fontSize: 24, fontWeight: FontWeight.w800);
  static const TextStyle headText = TextStyle(
      color: AppColors.defaultText, fontSize: 30, fontWeight: FontWeight.w800);
  static const TextStyle sendBtnText = TextStyle(
      color: AppColors.backgroud, fontSize: 24, fontWeight: FontWeight.w500);
}

InputDecoration textfieldStyle({required String hintText}) {
  var decoration = InputDecoration(
    border: OutlineInputBorder(),
    filled: true,
    focusedBorder: OutlineInputBorder(),
    fillColor: AppColors.backgroud,
    hintText: hintText,
  );
  return decoration;
}
