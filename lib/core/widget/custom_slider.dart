import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSlider extends StatelessWidget {
  final List<Widget>? items;
  final CarouselSliderController controller;
  final dynamic Function(int, CarouselPageChangedReason)? onPageChanged;
  final bool? autoPlay;

  const CustomSlider({
    super.key,
    required this.items,
    required this.controller,
    this.onPageChanged,
    this.autoPlay,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: controller,
      items: items,
      options: CarouselOptions(
        height: 320.h,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        onPageChanged: onPageChanged,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: autoPlay ?? true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

// class BuildHomeSlider extends StatefulWidget {
//   const BuildHomeSlider({
//     super.key,
//     required this.items,
//   });
//
//   final List<SliderEntity> items;
//
//   @override
//   State<BuildHomeSlider> createState() => _BuildHomeSliderState();
// }
//
// class _BuildHomeSliderState extends State<BuildHomeSlider> {
//   final CarouselSliderController controller = CarouselSliderController();
//
//   int currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 16.h),
//         CustomSlider(
//             controller: controller,
//             autoPlay: widget.items.length > 1,
//             items: widget.items.reversed.map((e) {
//               return InkWell(
//                 onTap: () {},
//                 child: CustomCachedImage(
//                   image: e.image.getImage,
//                   fit: BoxFit.cover,
//                 ),
//               );
//             }).toList(),
//             onPageChanged: (current, reason) {
//               setState(() {
//                 currentIndex = current;
//               });
//             }),
//         SizedBox(height: 13.h),
//         if (widget.items.length > 1)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               widget.items.length,
//               (index) {
//                 return IndicatorDotsWidget(
//                   index: index,
//                   isActive: index == currentIndex,
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
