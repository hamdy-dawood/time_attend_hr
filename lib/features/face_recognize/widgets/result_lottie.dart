import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

class ResultLottie extends StatelessWidget {
  const ResultLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          ImageManager.lottieSuccess,
          height: 70,
          repeat: false,
        ),
        5.verticalSpace,
        CustomText(
          text: "تطابق",
          color: AppColors.green,
          fontWeight: FontWeight.w500,
          fontSize: 22.sp,
        ),
      ],
    );
  }
}
