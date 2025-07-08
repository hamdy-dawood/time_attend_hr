import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final Icon? icon;
  final Widget? widget;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? color;
  final Color? fontColor;
  final double? width, height, fontSize;
  final TextStyle? textStyle;
  final bool isBorderButton;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.widget,
    this.color = AppColors.primary,
    this.splashColor,
    this.highlightColor,
    this.width,
    this.fontColor = Colors.white,
    this.textStyle,
    this.height,
    this.isBorderButton = false,
    this.borderRadius,
    this.padding,
    this.borderColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 50,
      decoration: isBorderButton
          ? BoxDecoration(
              // gradient: const LinearGradient(
              //   begin: Alignment(0.00, 1.00),
              //   end: Alignment(0, -1),
              //   colors: [Color(0xFFF6F6F6), Color(0xFFF4FCFA)],
              // ),
              borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
              border: Border.all(
                color: borderColor ?? Colors.black38,
              ),
            )
          : null,
      child: MaterialButton(
        onPressed: onTap,
        elevation: 0,
        // splashColor: splashColor ?? AppColors.primary.withOpacity(.1),
        //  highlightColor: highlightColor ?? AppColors.primary.withOpacity(.1),
        highlightElevation: 0,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
        ),
        color: color,
        child: text != null
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: CustomText(
                  text: text!,
                  color: fontColor!,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize ?? 14,
                ),
              )
            : icon ?? widget,
      ),
    );
  }
}
