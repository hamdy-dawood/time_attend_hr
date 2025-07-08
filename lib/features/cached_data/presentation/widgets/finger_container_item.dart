import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

class FingerContainerItem extends StatelessWidget {
  const FingerContainerItem({
    super.key,
    required this.title,
    required this.count,
    required this.isUploaded,
  });

  final String title, count;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isUploaded
              ? [
                  const Color(0xFF059669),
                  const Color(0xFF16A34A),
                ]
              : [
                  const Color(0xFFF871A0),
                  const Color(0xFFF31260),
                ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30.sp,
                ),
                const SizedBox(height: 10),
                FittedBox(
                  child: CustomText(
                    text: count,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          SvgIcon(
            icon: isUploaded ? ImageManager.fingerYes : ImageManager.fingerNo,
            height: 28.h,
            color: AppColors.white,
          )
        ],
      ),
    );
  }
}
