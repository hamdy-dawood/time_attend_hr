import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';

import 'custom_text.dart';

class TablePaginationContainer extends StatelessWidget {
  const TablePaginationContainer({
    super.key,
    required this.onTap,
    required this.number,
    this.selected = false,
  });

  final Function()? onTap;
  final String number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: selected ? AppColors.primary : AppColors.grey, width: 1.5),
          ),
          child: Center(
            child: CustomText(
              text: number,
              color: selected ? AppColors.white : AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
