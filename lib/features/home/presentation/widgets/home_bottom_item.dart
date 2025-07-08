import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

class HomeBottomItem extends StatelessWidget {
  const HomeBottomItem({super.key, required this.icon, required this.text, required this.onTap});

  final String icon, text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.border2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.grey13,
                      border: Border.all(color: AppColors.border2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgIcon(
                      icon: icon,
                      color: AppColors.grey8,
                      height: 22,
                    ),
                  ),
                  const SizedBox(width: 20),
                  CustomText(
                    text: text,
                    color: AppColors.black3,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ],
              ),
              Transform.rotate(
                angle: Directionality.of(context) == TextDirection.ltr ? -3.2 / 2 : 3.2 / 2,
                child: IconButton(
                  onPressed: onTap,
                  icon: const SvgIcon(
                    icon: ImageManager.arrowDown,
                    color: AppColors.grey,
                    height: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
