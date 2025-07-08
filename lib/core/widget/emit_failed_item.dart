import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class EmitFailedItem extends StatelessWidget {
  const EmitFailedItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: text,
        color: AppColors.red,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}
