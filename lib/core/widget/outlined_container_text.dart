import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

class OutlinedContainerText extends StatelessWidget {
  const OutlinedContainerText({
    super.key,
    required this.text,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.containerColor,
    this.fontColor,
    this.borderColor,
    this.onTap,
  });

  final String text;
  final double? width, fontSize;
  final FontWeight? fontWeight;
  final Color? containerColor, fontColor, borderColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(80.r),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(80.r),
          border: Border.all(color: borderColor ?? AppColors.border),
        ),
        child: CustomText(
          text: text,
          color: fontColor ?? AppColors.black2,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
