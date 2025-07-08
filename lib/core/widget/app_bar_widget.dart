import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';

import '../utils/image_manager.dart';
import 'custom_text.dart';
import 'svg_icons.dart';

AppBar mainAppBarWidget(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.grey2,
    surfaceTintColor: AppColors.white,
    elevation: 0,
    leadingWidth: 0,
    leading: const SizedBox.shrink(),
    iconTheme: const IconThemeData(
      color: AppColors.primary,
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const SvgIcon(
                icon: ImageManager.cancelBack,
                color: AppColors.black,
                height: 28,
              ),
            ),
            const SizedBox(width: 10),
            const CustomText(
              text: "داشبورد",
              color: AppColors.black2,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ],
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: const SvgIcon(
        //     icon: ImageManager.notification,
        //     color: AppColors.grey,
        //     height: 22,
        //   ),
        // ),
      ],
    ),
    toolbarHeight: 80,
  );
}
