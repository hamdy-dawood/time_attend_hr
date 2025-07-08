// import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';

import 'custom_text.dart';

DataColumn customDataColumn(
  String title, {
  double? fontSize,
  FontWeight? fontWeight,
  double? width,
}) {
  return DataColumn(
    label: Expanded(
      child: SizedBox(
        width: width,
        child: CustomText(
          text: title,
          color: AppColors.grey8,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    ),
  );
}

//===============================================================================

DataCell customDataCell(
  String text, {
  double? fontSize,
  VoidCallback? onTap,
  double? width,
  Widget? widget,
  FontWeight? fontWeight,
  Color? fontColor,
  bool isContainer = false,
  bool isWidget = false,
}) {
  return DataCell(
    onTap: onTap,
    isContainer
        ? Center(
            child: Container(
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: fontColor!.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                text: text,
                color: fontColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : isWidget
            ? Center(child: widget!)
            : SizedBox(
                width: width,
                child: Center(
                  child: CustomText(
                    text: text,
                    color: fontColor ?? AppColors.black2,
                    fontSize: fontSize ?? 14,
                    fontWeight: fontWeight ?? FontWeight.w500,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
  );
}

//===============================================================================

DataCell dataCellRichText(String text, text2) {
  return DataCell(RichText(
    text: TextSpan(
      text: "$text ",
      style: const TextStyle(
        color: AppColors.black3,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      children: [
        TextSpan(
          text: text2,
          style: const TextStyle(
            color: AppColors.grey4,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    ),
  ));
}

//===============================================================================

DataCell onlyImageDataCell({
  required String image,
  bool isCircle = false,
}) {
  return DataCell(
    GestureDetector(
      onTap: () {
        // js.context.callMethod('open', ["${ApiConstants.baseImagesUrl}$image"]);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(10.r),
          // image: DecorationImage(
          //   image: NetworkImage("${ApiConstants.baseImagesUrl}$image"),
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    ),
  );
}
