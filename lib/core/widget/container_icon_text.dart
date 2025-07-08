import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

class ContainerIconText extends StatelessWidget {
  const ContainerIconText({super.key, required this.icon, required this.text, this.iconColor});

  final String icon, text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.circular(80.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIcon(
            icon: icon,
            color: iconColor ?? AppColors.grey8,
            height: 18,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: CustomText(
              text: text,
              color: AppColors.grey8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
