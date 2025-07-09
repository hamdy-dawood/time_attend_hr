import 'package:flutter/material.dart';

class HomeItemEntity {
  final String icon;
  final String text;
  final double? textSize;
  final String subTitle, tabTitle;
  final String route;
  final bool isImage;
  final Color iconColor, iconBgColor;

  HomeItemEntity({
    required this.icon,
    required this.text,
    this.textSize,
    required this.subTitle,
    required this.tabTitle,
    required this.route,
    this.isImage = false,
    required this.iconColor,
    required this.iconBgColor,
  });
}
