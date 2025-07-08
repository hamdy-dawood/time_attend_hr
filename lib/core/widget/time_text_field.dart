import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

class TimeTextField extends StatelessWidget {
  const TimeTextField({super.key, required this.controller, required this.title, required this.hintText, required this.cubit});

  final TextEditingController controller;
  final String title, hintText;
  final dynamic cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      title: title,
      titleFontSize: 16,
      titleFontWeight: FontWeight.w500,
      titleColor: AppColors.grey,
      controller: controller,
      borderRadius: 6,
      hintText: hintText,
      filledColor: AppColors.white,
      readOnly: true,
      onTap: () {
        cubit.pressTime(context, controller: controller);
      },
      suffixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
          onPressed: () {
            cubit.pressTime(context, controller: controller);
          },
          icon: const SvgIcon(
            icon: ImageManager.clockOutlined,
            color: AppColors.black2,
            height: 18,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "ادخل $title !";
        }
        return null;
      },
    );
  }
}
