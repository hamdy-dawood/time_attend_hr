import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_alert.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: "logOut".tr(),
              body: "logout_text".tr(),
              submitWidget: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                ),
                onPressed: () {
                  Caching.removeData(key: "profile");
                  Caching.removeData(key: "access_token");
                  Caching.removeData(key: "refresh_token");
                  context.pushNamedAndRemoveUntil(
                    Routes.login,
                    predicate: (Route<dynamic> route) => false,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: CustomText(
                    text: "logout".tr(),
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const SvgIcon(
        icon: ImageManager.logout,
        color: AppColors.grey,
        height: 22,
      ),
    );
  }
}
