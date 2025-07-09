import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/pick_image_sheet.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import 'header_top.dart';

class IdentifyContainer extends StatelessWidget {
  const IdentifyContainer({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: AppColors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      controller: cubit.identifyController,
                      hintText: "حد التعرف",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return null;
                      },
                      isLastInput: true,
                      title: "حد التعرف",
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      MagicRouter.pop();
                    },
                    child: const CustomText(
                      text: "الغاء",
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: 80,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        cubit.updateIdentifyThreshold(context);
                      },
                      child: const CustomText(
                        text: "حفظ",
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: SettingsItem(
            title: "حد التعرف",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: CustomText(
                    text: cubit.identifyController.text,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                10.horizontalSpace,
                const DefaultCircleIcon(
                  icon: ImageManager.leftArrow,
                  circleRadius: 16,
                  height: 23,
                  circleColor: AppColors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
