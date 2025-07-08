import 'package:flutter/material.dart';

import 'custom_text.dart';

class EmitNetworkItem extends StatelessWidget {
  const EmitNetworkItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(
        text: "لا يوجد اتصال بالانترنت",
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
