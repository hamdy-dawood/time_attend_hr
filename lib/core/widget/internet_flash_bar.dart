import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';

import 'custom_text.dart';

void showConnectionStatus({
  required String title,
  required String message,
  required String icon,
  Color? iconColor,
  required int durationInSeconds,
}) {
  Flushbar(
    mainButton: Padding(
      padding: const EdgeInsets.all(16),
      child: IconButton(
        icon: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          Navigator.maybePop(navigatorKey.currentContext!);
        },
      ),
    ),
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: Colors.black.withOpacity(.7),
    borderRadius: BorderRadius.circular(16),
    barBlur: 5,
    messageText: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            icon,
            width: 40,
            colorFilter: ColorFilter.mode(
              iconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                maxLines: 3,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: message,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    ),
    duration: Duration(seconds: durationInSeconds),
  ).show(navigatorKey.currentContext!);
}
