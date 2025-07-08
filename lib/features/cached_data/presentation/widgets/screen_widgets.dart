import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';

import '../widgets/finger_container_item.dart';

class CachedDataRowHeaderWidget extends StatelessWidget {
  const CachedDataRowHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            ImageManager.cancelBack,
            height: 28,
          ),
        ),
        const SizedBox(width: 10),
        const Flexible(
          child: CustomText(
            text: "سجل البصمات",
            color: AppColors.black2,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

class CachedDataSearchTextField extends StatelessWidget {
  const CachedDataSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      title: "",
      controller: context.read<HomeCubit>().searchController,
      borderRadius: 10,
      hintText: "بحث بإسم الموظف...",
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SvgIcon(
          icon: ImageManager.search,
          color: AppColors.grey4,
          height: 20,
        ),
      ),
      suffixIcon: IconButton(
        onPressed: () {
          context.read<HomeCubit>().pressFacesDate(context);
        },
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: SvgIcon(
            icon: ImageManager.filter,
            color: AppColors.grey14,
            height: 25,
          ),
        ),
      ),
      onChanged: (value) {
        context.read<HomeCubit>().searchCachedFaces(context.read<HomeCubit>().searchController.text);
      },
    );
  }
}

class CachedDataRowCountData extends StatelessWidget {
  const CachedDataRowCountData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return Row(
          children: [
            Expanded(
              child: FingerContainerItem(
                title: "البصمات المسجلة",
                count: "${cubit.getUploadedCount()}",
                isUploaded: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FingerContainerItem(
                title: "البصمات الغير المسجلة",
                count: "${cubit.getUnUploadedCount()}",
                isUploaded: false,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ControlContainer extends StatelessWidget {
  const ControlContainer({super.key, required this.color, required this.icon, required this.title, this.onTap});

  final Color color;
  final String icon, title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Row(
          children: [
            SvgIcon(
              icon: icon,
              color: AppColors.white,
              height: 22,
            ),
            if (context.screenWidth > 500)
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
