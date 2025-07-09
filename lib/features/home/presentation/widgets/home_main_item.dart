import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';
import 'package:time_attend_recognition/features/face_recognize/presentation/teacher_face_recognition_view.dart';

import '../../domain/entities/home_item_entity.dart';
import '../cubit/home_cubit.dart';

class HomeMainItem extends StatelessWidget {
  const HomeMainItem({
    super.key,
    required this.item,
    this.isImage = false,
  });

  final HomeItemEntity item;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.route == "faceId") {
          MagicRouter.navigateTo(
            page: TeacherFaceRecognitionView(
              homeCubit: context.read<HomeCubit>(),
            ),
          );
        } else {
          context.pushNamed(item.route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border2),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: item.isImage
                        ? Image.asset(
                            item.icon,
                            height: 25,
                          )
                        : SvgPicture.asset(
                            item.icon,
                            height: 25,
                            colorFilter: ColorFilter.mode(item.iconColor, BlendMode.srcIn),
                          ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomText(
                      text: item.text,
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: item.textSize ?? 16,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomText(
                text: item.subTitle,
                color: AppColors.grey8,
                fontWeight: FontWeight.w500,
                fontSize: item.textSize ?? 14,
                maxLines: 2,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    child: CustomText(
                      text: item.tabTitle,
                      color: item.iconColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5),
                  RotatedBox(
                    quarterTurns: 2,
                    child: SvgIcon(
                      icon: ImageManager.leftArrow2,
                      color: item.iconColor,
                      height: 20,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
