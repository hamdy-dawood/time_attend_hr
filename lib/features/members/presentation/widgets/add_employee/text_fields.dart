import 'package:flutter/material.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import '../../cubit/employees_cubit.dart';

class EmployeeNameTextField extends StatelessWidget {
  const EmployeeNameTextField({super.key, required this.cubit});

  final EmployeesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      title: "اسم الموظف",
      titleFontSize: 16,
      titleFontWeight: FontWeight.w500,
      titleColor: AppColors.grey,
      controller: cubit.nameController,
      borderRadius: 6,
      hintText: "اسم الموظف",
      filledColor: AppColors.white,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "ادخل اسم الموظف !";
        }
        return null;
      },
    );
  }
}
