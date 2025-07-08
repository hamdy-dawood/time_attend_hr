import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    required this.title,
    required this.body,
    required this.submitWidget,
  });

  final String title, body;
  final Widget submitWidget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: CustomText(
        text: title,
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      content: CustomText(
        text: body,
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        maxLines: 5,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: CustomText(
              text: "cancel".tr(),
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        submitWidget,
      ],
    );
  }
}

// CustomAlert(
// title: "Delete User",
// body: "Are you sure you want to delete",
// submitWidget: const SizedBox(),
// );
