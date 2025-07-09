import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

import '../../domain/entities/home_item_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/home_main_item.dart';
import 'header_top.dart';

class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColors.white, boxShadow: [
            BoxShadow(
              color: AppColors.grey2,
              offset: Offset(0, 1),
            )
          ]),
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              HeaderTop(cubit: cubit),
              const SizedBox(height: 10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CustomText(
                          text: "لوحة التحكم الرئيسية",
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                        SizedBox(height: 5),
                        CustomText(
                          text: "اختر العملية المطلوبة من الخيارات أدناه",
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
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
      HomeItemEntity(
        icon: ImageManager.peoplesOutlined,
        text: "إدارة الطلاب",
        subTitle: "عرض وإدارة بيانات الطلاب المسجلين",
        tabTitle: "انقر للدخول",
        route: Routes.employees,
        iconColor: AppColors.primary,
        iconBgColor: AppColors.primary.withOpacity(0.1),
      ),
      if (!kIsWeb)
        if (Platform.isAndroid || Platform.isIOS)
          HomeItemEntity(
            icon: ImageManager.cameraAdd,
            text: "تسجيل حضور جماعي",
            subTitle: "فتح الكاميرا وبدء عملية تسجيل الحضور للجلسة",
            tabTitle: "انقر للبدء",
            route: "faceId",
            iconColor: AppColors.green,
            iconBgColor: AppColors.green.withOpacity(0.1),
          ),
      HomeItemEntity(
        icon: ImageManager.active,
        text: "حضور عن طريق الاستاذ",
        subTitle: "تحديد هوية الأستاذ وتسجيل حضور الطلاب يدويا",
        tabTitle: "انقر للبدء",
        route: "manualAttendance",
        iconColor: AppColors.purple,
        iconBgColor: AppColors.purple.withOpacity(0.1),
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
              mainAxisExtent: 190,
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
