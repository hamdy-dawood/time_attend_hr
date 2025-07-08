import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    this.validator,
    this.isLastInput = false,
    this.readOnly = false,
    this.isoCode = "IQ",
    this.autoValidate = AutovalidateMode.onUserInteraction,
    this.onTap,
    required this.title,
    this.hint = "",
    this.onInputChanged,
  });

  final Function(PhoneNumber)? onInputChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final bool isLastInput, readOnly;
  final String title, hint;
  final String? isoCode;
  final AutovalidateMode autoValidate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: CustomText(
              text: title,
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        IntlPhoneField(
          readOnly: readOnly,
          onTap: onTap,
          initialCountryCode: isoCode,
          onChanged: onInputChanged,
          validator: validator ??
              (value) {
                if (value == null || value.number.isEmpty) {
                  return "enter_phone".tr();
                }
                return null;
              },
          invalidNumberMessage: "enter_correct_phone".tr(),
          autovalidateMode: autoValidate,
          dropdownIconPosition: IconPosition.trailing,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: AppConstance.appFontName,
          ),
          textInputAction: isLastInput ? TextInputAction.done : TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          dropdownIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.primary,
          ),
          flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            counterStyle: const TextStyle(fontSize: 0),
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.grey5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.grey5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.primary,
                ),
                borderRadius: BorderRadius.circular(12)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.red,
                ),
                borderRadius: BorderRadius.circular(12)),
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: AppConstance.appFontName,
            ),
          ),
        ),
      ],
    );
  }
}
