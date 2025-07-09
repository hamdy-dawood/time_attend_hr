import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

import '../../home/presentation/cubit/home_cubit.dart';

class AttendResultDialog extends StatelessWidget {
  const AttendResultDialog({
    super.key,
    required this.name,
    required this.homeCubit,
  });

  final String name;
  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      title: const CustomText(
        text: "تم التسجيل",
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        maxLines: 3,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            ImageManager.lottieSuccess,
            height: 70,
            repeat: false,
          ),
          const SizedBox(height: 10),
          // ClipOval(
          //   child: SizedBox.fromSize(
          //     size: const Size.fromRadius(70),
          //     child: CustomCachedImage(
          //       image: employee.image,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          CustomText(
            text: name,
            color: AppColors.black2,
            fontWeight: FontWeight.w500,
            fontSize: 22,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
