import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

import '../../domain/entities/home_item_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/home_main_item.dart';
import 'count_item.dart';
import 'header_top.dart';

class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 1.sw,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  HeaderTop(cubit: cubit),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // context.read<HomeCubit>().getReport();
              // context.read<HomeCubit>().getHome();
              // context.read<HomeCubit>().loadCachedFaces();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 50.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!kIsWeb)
                          Flexible(
                            child: CustomText(
                              text: "الرئيسية",
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 26,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
                  //   return Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 100.w),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         if (context.screenWidth < 700)
                  //           Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               CountItemRow(
                  //                 title: "عدد الحضور",
                  //                 count: "${cubit.presentCount}",
                  //                 status: 1,
                  //               ),
                  //               SizedBox(height: 16.w),
                  //               CountItemRow(
                  //                 title: "عدد الغياب",
                  //                 count: "${cubit.absentCount}",
                  //                 status: 0,
                  //               ),
                  //             ],
                  //           )
                  //         else
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [
                  //               Expanded(
                  //                 child: CountItemColumn(
                  //                   title: "عدد الحضور",
                  //                   count: "${cubit.presentCount}",
                  //                   status: 1,
                  //                 ),
                  //               ),
                  //               SizedBox(width: 16.w),
                  //               Expanded(
                  //                 child: CountItemColumn(
                  //                   title: "عدد الغياب",
                  //                   count: "${cubit.absentCount}",
                  //                   status: 0,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  // const SizedBox(height: 10),
                  BlocBuilder<HomeCubit, HomeStates>(
                    builder: (context, state) {
                      return LayoutHeaderBody(cubit: cubit);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LayoutHeaderBody extends StatelessWidget {
  const LayoutHeaderBody({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    final List<HomeItemEntity> items = [
      if (!kIsWeb)
        if (Platform.isAndroid || Platform.isIOS)
          HomeItemEntity(
            icon: ImageManager.face,
            text: "بدئ التعرف",
            count: "",
            route: "faceId",
            textSize: 20,
          ),
      HomeItemEntity(
        icon: ImageManager.employees,
        text: "الموظفون",
        count: "",
        route: Routes.employees,
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(right: 100.w, left: 100.w, bottom: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (context.screenWidth >= 1000) {
            crossAxisCount = 4;
          } else if (context.screenWidth >= 750) {
            crossAxisCount = 3;
          } else if (context.screenWidth >= 500) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 1;
          }
          return GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 16.w,
              mainAxisExtent: 150,
            ),
            itemBuilder: (context, index) {
              return HomeMainItem(item: items[index]);
            },
          );
        },
      ),
    );
  }
}
