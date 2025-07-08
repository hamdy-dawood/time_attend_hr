class HomeItemEntity {
  final String icon;
  final String text;
  final double? textSize;
  final String count;
  final String route;
  final bool isImage;

  HomeItemEntity({
    required this.icon,
    required this.text,
    this.textSize,
    required this.count,
    required this.route,
    this.isImage = false,
  });
}
