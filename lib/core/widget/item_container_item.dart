import 'package:flutter/material.dart';

import 'custom_text.dart';

class ItemContainerWidget extends StatelessWidget {
  const ItemContainerWidget({
    super.key,
    this.onTap,
    required this.title,
    this.color,
  });

  final Function()? onTap;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: color ?? Colors.transparent),
            ),
            child: Center(
              child: CustomText(
                text: title,
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
