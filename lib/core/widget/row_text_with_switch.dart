import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class RowTextWithSwitch extends StatelessWidget {
  const RowTextWithSwitch({
    super.key,
    required this.bodyText,
    required this.switchValue,
    required this.onChanged,
  });

  final String bodyText;
  final bool switchValue;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsetsDirectional.only(start: 10, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomText(
              text: bodyText,
              color: AppColors.black,
              fontSize: 14,
              maxLines: 3,
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              hoverColor: AppColors.transparent,
              focusColor: AppColors.transparent,
              trackColor: switchValue ? WidgetStateProperty.all(AppColors.primary) : WidgetStateProperty.all(AppColors.white),
              thumbColor: switchValue ? WidgetStateProperty.all(AppColors.white) : WidgetStateProperty.all(AppColors.grey8),
              activeColor: AppColors.primary,
              value: switchValue,
              onChanged: (value) {
                onChanged(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
