import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:lottie/lottie.dart';

class UploadCachedFacesLoadingDialog extends StatelessWidget {
  const UploadCachedFacesLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText(
            text: "جاري تسجيل البصمات ...",
            color: AppColors.black2,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
          Center(
            child: Lottie.asset(
              ImageManager.lottieLoading,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
