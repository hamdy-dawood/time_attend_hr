import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';

class SecTabBar extends StatelessWidget {
  const SecTabBar({
    super.key,
    this.tabController,
    this.onTap,
    required this.tabs,
    this.isScrollable = false,
  });

  final TabController? tabController;
  final Function(int)? onTap;
  final List<String> tabs;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: isScrollable,
      tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.primary,
      indicatorWeight: 3,
      dividerColor: AppColors.border,
      labelPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      indicatorPadding: EdgeInsets.zero,
      unselectedLabelColor: AppColors.grey8,
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontFamily: AppConstance.appFontName,
        fontWeight: FontWeight.w500,
      ),
      labelColor: AppColors.black3,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontFamily: AppConstance.appFontName,
        fontWeight: FontWeight.w600,
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      tabs: List.generate(
        tabs.length,
        (index) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                tabs[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
