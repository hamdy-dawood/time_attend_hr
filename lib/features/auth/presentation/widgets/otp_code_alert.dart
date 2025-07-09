import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';

import '../cubit/register/register_cubit.dart';
import '../cubit/register/register_states.dart';

class OtpCodeAlert extends StatelessWidget {
  const OtpCodeAlert({super.key, required this.cubit});

  final RegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.mainBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      title: CustomText(
        text: "enter_code".tr(),
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              text: "enter_code_desc".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                TextSpan(
                  text: cubit.phoneNumber,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Localizations.override(
            context: context,
            locale: const Locale("en"),
            child: BlocBuilder<RegisterCubit, RegisterStates>(
              builder: (context, state) {
                return PinPutWidget(
                  controller: cubit.codeController,
                );
              },
            ),
          ),
          OtpTimerButton(
            duration: 90,
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            onPressed: () {
              cubit.reSendCode();
            },
            text: Text(
              "resend".tr(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: AppConstance.appFontName,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: BlocConsumer<RegisterCubit, RegisterStates>(
              listener: (context, state) {
                if (state is RegisterSuccessState) {
                  context.pushNamedAndRemoveUntil(
                    Routes.home,
                    predicate: (Route<dynamic> route) => false,
                  );
                } else if (state is RegisterFailState) {
                  showToastificationWidget(
                    message: state.message,
                    context: context,
                  );
                }
              },
              builder: (context, state) {
                if (state is RegisterLoadingState) {
                  return const EmitLoadingItem();
                }
                return CustomButton(
                  height: 48.h,
                  width: double.infinity,
                  borderRadius: 6,
                  text: "confirm".tr(),
                  color: AppColors.primary,
                  onTap: () {
                    if (cubit.codeController.length == 6) {
                      cubit.register();
                    } else {
                      showToastificationWidget(
                        message: "Please Enter Full Code",
                        context: context,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PinPutWidget extends StatelessWidget {
  final TextEditingController controller;

  const PinPutWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale("en"),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Pinput(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          length: 6,
          controller: controller,
          defaultPinTheme: _buildPinTheme(context),
          focusedPinTheme: _buildPinTheme(context, focused: true),
          errorPinTheme: _buildPinTheme(context, hasError: true),
        ),
      ),
    );
  }

  PinTheme _buildPinTheme(BuildContext context, {bool focused = false, bool hasError = false}) {
    return PinTheme(
      height: 56,
      width: 56,
      textStyle: const TextStyle(
        color: AppColors.black,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        fontFamily: AppConstance.appFontName,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 1.5,
          color: hasError
              ? AppColors.red
              : focused
                  ? AppColors.primary
                  : AppColors.grey,
        ),
      ),
    );
  }
}
