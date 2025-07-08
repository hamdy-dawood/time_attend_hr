import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

class ResultDataItem extends StatelessWidget {
  const ResultDataItem({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title, value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            color: AppColors.grey3,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
          Flexible(
            child: CustomText(
              text: value,
              color: valueColor ?? AppColors.grey3,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
