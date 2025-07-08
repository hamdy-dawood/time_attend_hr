import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomDropItem extends StatelessWidget {
  const CustomDropItem({
    super.key,
    required this.icon,
    required this.title,
    required this.textColor,
    this.iconColor,
  });

  final String icon, title;
  final Color textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if (icon.isNotEmpty)
        //   Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           color: AppColors.white,
        //           shape: BoxShape.circle,
        //           border: Border.all(color: AppColors.grey9),
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.all(10),
        //           child: SvgIcon(
        //             icon: icon,
        //             color: iconColor ?? textColor,
        //             height: 18,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 10),
        //     ],
        //   ),
        CustomText(
          text: title,
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ],
    );
  }
}
