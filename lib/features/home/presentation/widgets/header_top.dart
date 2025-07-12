import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import 'identify_container.dart';
import 'live_container.dart';
import 'live_level_container.dart';
import 'logout_button.dart';

class HeaderTop extends StatelessWidget {
  const HeaderTop({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: SvgIcon(
                        icon: ImageManager.graduate,
                        color: AppColors.white,
                        height: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        // cubit.getHome();
                        // cubit.getReport();
                        cubit.loadCachedFaces();
                      },
                      child: const CustomText(
                        text: "نظام حضور الطلاب",
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // if (context.screenWidth >= 700) const Flexible(child: LoadingUploadWidget()),
            Row(
              children: [
                if (Caching.get(key: 'role') == "admin")
                  IconButton(
                    onPressed: () {
                      cubit.loadSettings();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlocProvider.value(
                            value: cubit,
                            child: SettingAlertDialog(cubit: cubit),
                          );
                        },
                      );
                    },
                    icon: const SvgIcon(
                      icon: ImageManager.settings,
                      color: AppColors.grey,
                      height: 22,
                    ),
                  ),
                const LogoutButton(),
              ],
            )
          ],
        ),
        // if (context.screenWidth < 700)
        //   const Padding(
        //     padding: EdgeInsets.only(top: 10),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Flexible(child: LoadingUploadWidget()),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
}

// class LoadingUploadWidget extends StatelessWidget {
//   const LoadingUploadWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeStates>(
//       builder: (context, state) {
//         final cubit = context.read<HomeCubit>();
//
//         if (cubit.isReUpload) {
//           final int uploadedCount = cubit.uploadedCount;
//           final int totalCount = cubit.totalCount;
//
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomText(
//                 text: "جاري تسجيل البصمات ... ($uploadedCount / $totalCount)",
//                 color: AppColors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//               ),
//               const SizedBox(height: 10),
//               LinearPercentIndicator(
//                 lineHeight: 8,
//                 percent: totalCount == 0 ? 0 : (uploadedCount / totalCount).clamp(0.0, 1.0),
//                 backgroundColor: AppColors.white.withOpacity(0.5),
//                 progressColor: AppColors.primary,
//                 animation: true,
//                 animateFromLastPercent: true,
//                 curve: Curves.easeInOut,
//                 animationDuration: 800,
//                 barRadius: const Radius.circular(10),
//                 isRTL: true,
//               ),
//             ],
//           );
//         } else {
//           return const SizedBox();
//         }
//       },
//     );
//   }
// }

class SettingAlertDialog extends StatefulWidget {
  const SettingAlertDialog({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  State<SettingAlertDialog> createState() => _SettingAlertDialogState();
}

class _SettingAlertDialogState extends State<SettingAlertDialog> {
  @override
  void initState() {
    int cameraLens = Caching.get(key: AppConstance.cameraLensKey) ?? 1;
    int configReAttend = Caching.get(key: "configReAttend") ?? 30;
    int waitingDetect = Caching.get(key: "waitingDetect") ?? 120;

    widget.cubit.frontCamera = cameraLens == 1 ? true : false;
    widget.cubit.configReAttendController.text = configReAttend.toString();
    widget.cubit.waitingController.text = waitingDetect.toString();
    widget.cubit.loadVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      content: SizedBox(
        width: context.screenWidth * 0.45,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: CustomText(
                      text: "الإعدادات",
                      color: AppColors.black2,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      ImageManager.cancelCircle,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  return FittedBox(
                    child: CustomText(
                      text: "الإصدار : ${widget.cubit.version}",
                      color: AppColors.black2,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: "الكاميرا",
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              SizedBox(height: 10.h),
              SettingsItem(
                title: "عدسة الكاميرا الأمامية",
                trailing: BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) {
                    return CupertinoSwitch(
                      activeColor: AppColors.primary,
                      thumbColor: AppColors.white,
                      trackColor: AppColors.grey,
                      value: widget.cubit.frontCamera,
                      onChanged: (value) {
                        widget.cubit.changeFrontCamera();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // CustomTextFormField(
              //   title: "مهلة الفحص",
              //   titleFontSize: 16,
              //   titleFontWeight: FontWeight.w500,
              //   titleColor: AppColors.grey,
              //   controller: widget.cubit.configReAttendController,
              //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //   keyboardType: TextInputType.number,
              //   borderRadius: 6,
              //   hintText: "مهلة الفحص بالثواني...",
              //   filledColor: AppColors.white,
              // ),
              // const SizedBox(height: 20),
              // CustomTextFormField(
              //   title: "مهلة الانتظار",
              //   titleFontSize: 16,
              //   titleFontWeight: FontWeight.w500,
              //   titleColor: AppColors.grey,
              //   controller: widget.cubit.waitingController,
              //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //   keyboardType: TextInputType.number,
              //   borderRadius: 6,
              //   hintText: "مهلة الانتظار بالثواني...",
              //   filledColor: AppColors.white,
              // ),
              // const SizedBox(height: 30),
              // CustomText(
              //   text: "الحد",
              //   color: AppColors.black2,
              //   fontWeight: FontWeight.w500,
              //   fontSize: 16.sp,
              // ),
              // 5.verticalSpace,
              LiveLevelContainer(cubit: widget.cubit),
              LiveContainer(cubit: widget.cubit),
              IdentifyContainer(cubit: widget.cubit),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(249, 249, 249, 1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color.fromRGBO(246, 246, 246, 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FittedBox(
              child: CustomText(
                text: title,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (trailing != null) Flexible(child: trailing!),
        ],
      ),
    );
  }
}
