import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:toastification/toastification.dart';

import '../../../domain/entities/employees_entity.dart';
import '../../cubit/employees_cubit.dart';
import '../../cubit/employees_states.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key, this.member, required this.isEdit, required this.membersCubit});

  final EmployeesCubit membersCubit;
  final EmployeesEntity? member;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeesCubit, EmployeesStates>(
      listener: (context, state) {
        if (state is AddEmployeesSuccessState) {
          Navigator.pop(context);
          if (state.statusCode == 422) {
            showToastificationWidget(
              message: state.message ?? "",
              context: context,
              notificationType: ToastificationType.error,
            );
          } else {
            showToastificationWidget(
              message: isEdit ? "edit_successfully".tr() : "add_successfully".tr(),
              context: context,
              notificationType: ToastificationType.success,
            );
          }
          membersCubit.getEmployees();
        } else if (state is AddEmployeesFailState) {
          showToastificationWidget(
            message: state.message,
            context: context,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<EmployeesCubit>();

        if (state is AddEmployeesLoadingState) {
          return const EmitLoadingItem(color: AppColors.primary);
        }
        return CustomButton(
          onTap: () {
            if (isEdit) {
              cubit.editMembers(id: member!.id);
            } else {
              if (cubit.employeeImage == null) {
                showToastificationWidget(
                  context: context,
                  message: "الرجاء اختيار صورة الموظف",
                  notificationType: ToastificationType.error,
                );
              } else {
                cubit.addMembers();
              }
            }
          },
          height: 48,
          borderRadius: 6,
          color: AppColors.primary,
          fontColor: Colors.white,
          text: isEdit ? "تعديل" : "اضافة",
          fontSize: 18,
        );
      },
    );
  }
}
