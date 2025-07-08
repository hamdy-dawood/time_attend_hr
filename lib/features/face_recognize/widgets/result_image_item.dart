import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

class ResultImageItem extends StatelessWidget {
  const ResultImageItem({
    super.key,
    required this.child,
    required this.icon,
    required this.title,
  });

  final String icon, title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: child,
        ),
        8.verticalSpace,
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              SvgIcon(
                icon: icon,
                color: AppColors.grey3,
                height: 22,
              ),
              8.horizontalSpace,
              Expanded(
                child: CustomText(
                  text: title,
                  color: AppColors.grey3,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
