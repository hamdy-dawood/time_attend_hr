import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/features/face_recognize/presentation/face_recognition_view.dart';
import 'package:time_attend_recognition/features/face_recognize/presentation/teacher_face_recognition_view.dart';

import '../../domain/entities/home_item_entity.dart';
import '../cubit/home_cubit.dart';

class HomeMainItem extends StatelessWidget {
  const HomeMainItem({super.key, required this.item, this.isImage = false});

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
          color: AppColors.grey13,
          border: Border.all(color: AppColors.grey6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
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
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: 20, top: item.count.isEmpty ? 10 : 0),
                      child: CustomText(
                        text: item.text,
                        color: AppColors.grey8,
                        fontWeight: FontWeight.w500,
                        fontSize: item.textSize ?? 14,
                      ),
                    ),
                  ),
                  // if (item.count.isNotEmpty)
                  //   CustomText(
                  //     text: NumberFormat.decimalPattern('en').format(int.parse(item.count)),
                  //     color: AppColors.black3,
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 28,
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
