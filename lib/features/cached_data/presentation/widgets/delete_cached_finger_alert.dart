import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_alert.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';

class DeleteCachedFingerAlert extends StatelessWidget {
  const DeleteCachedFingerAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAlert(
      title: "delete".tr(),
      body: "confirm_delete".tr(args: ["جميع البصمات المسجلة"]),
      submitWidget: TextButton(
        onPressed: () {
          // Caching.removeData(key: "face_detection");
          showToastificationWidget(
            message: "deleted_successfully".tr(),
            context: context,
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.red,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomText(
            text: "delete".tr(),
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
