import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/pick_image_sheet.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import 'header_top.dart';

class LiveLevelContainer extends StatelessWidget {
  const LiveLevelContainer({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return Container(
                  height: 216,
                  padding: const EdgeInsets.only(top: 6.0),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  child: SafeArea(
                    top: false,
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: cubit.selectedLivenessLevel,
                      ),
                      onSelectedItemChanged: (int selectedItem) {
                        cubit.onSelectedItemChanged(selectedItem);
                      },
                      children: List<Widget>.generate(_liveLevelNames.length, (int index) {
                        return Center(child: Text(_liveLevelNames[index]));
                      }),
                    ),
                  ),
                );
              },
            );
          },
          child: SettingsItem(
            title: "مستوي الحيوية",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: _liveLevelNames[cubit.selectedLivenessLevel],
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                10.horizontalSpace,
                const DefaultCircleIcon(
                  icon: ImageManager.leftArrow,
                  circleRadius: 16,
                  height: 23,
                  circleColor: AppColors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LivenessDetectionLevel {
  String levelName;
  int levelValue;

  LivenessDetectionLevel(this.levelName, this.levelValue);
}

const List<String> _liveLevelNames = <String>[
  'Best Accuracy',
  'Light Weight',
];
