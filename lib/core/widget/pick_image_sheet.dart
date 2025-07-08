import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';

import '../utils/image_manager.dart';
import 'custom_text.dart';
import 'svg_icons.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({
    super.key,
    required this.cubit,
    required this.child,
    required this.onTapOne,
    required this.onTapTwo,
    required this.title,
  });

  final String title;
  final dynamic cubit;
  final Widget child;
  final VoidCallback onTapOne;
  final VoidCallback onTapTwo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _CustomAlert(
            mainTitle: title,
            title1: "choose_camera".tr(),
            title2: "choose_galley".tr(),
            image1: ImageManager.cameraAdd,
            image2: ImageManager.galleyAdd,
            onTapOne: onTapOne,
            onTapTwo: onTapTwo,
            iconColor: Colors.black,
          ),
        );
      },
      child: child,
    );
  }
}

class _CustomAlert extends StatelessWidget {
  const _CustomAlert({
    required this.mainTitle,
    required this.title1,
    required this.title2,
    required this.image1,
    required this.image2,
    required this.onTapOne,
    required this.onTapTwo,
    required this.iconColor,
  });

  final String mainTitle, title1, title2, image1, image2;
  final VoidCallback onTapOne;
  final VoidCallback onTapTwo;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.only(top: 20.h, bottom: 15.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: mainTitle,
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const DefaultCircleIcon(
                    icon: ImageManager.remove,
                    circleRadius: 16,
                    height: 16,
                    circleColor: Color.fromRGBO(240, 240, 240, 1),
                    iconColor: Color.fromRGBO(42, 42, 42, 1),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(
              thickness: 1.5.h,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          _CustomContainerForAlert(
            icon: image1,
            title: title1,
            onTap: onTapOne,
            iconColor: iconColor,
          ),
          SizedBox(height: 10.h),
          _CustomContainerForAlert(
            icon: image2,
            title: title2,
            onTap: onTapTwo,
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }
}

class _CustomContainerForAlert extends StatelessWidget {
  const _CustomContainerForAlert({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.iconColor,
  });

  final String title, icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: const Color.fromRGBO(246, 246, 246, 1),
        ),
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SvgIcon(
                  icon: icon,
                  height: 24,
                  color: iconColor,
                ),
              ),
              Expanded(
                child: CustomText(
                  text: title,
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultCircleIcon extends StatelessWidget {
  const DefaultCircleIcon({
    super.key,
    required this.icon,
    this.circleRadius,
    this.height,
    this.circleColor,
    this.iconColor,
  });

  final String icon;
  final double? circleRadius, height;
  final Color? circleColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: circleRadius ?? 24,
      backgroundColor: circleColor ?? Colors.white,
      child: SvgIcon(
        icon: icon,
        color: iconColor ?? const Color(0xFF555555),
        height: height ?? 24,
      ),
    );
  }
}
