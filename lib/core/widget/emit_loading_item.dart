import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/colors.dart';

class EmitLoadingItem extends StatelessWidget {
  const EmitLoadingItem({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? AppColors.primary,
        size: size ?? 40,
      ),
    );
  }
}

class EmitLoadingItemNoCenter extends StatelessWidget {
  const EmitLoadingItemNoCenter({super.key, this.size, this.color});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeArchedCircle(
      color: color ?? AppColors.primary,
      size: size ?? 40,
    );
  }
}
