import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_alert.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:toastification/toastification.dart';

import '../cubit/users_cubit.dart';
import '../cubit/users_states.dart';

class DeleteUsersEmployeesAlert extends StatelessWidget {
  const DeleteUsersEmployeesAlert({
    super.key,
    required this.cubit,
    required this.id,
    required this.name,
  });

  final String id, name;
  final UsersEmployeesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: CustomAlert(
        title: "delete".tr(),
        body: "confirm_delete".tr(args: [name]),
        submitWidget: BlocConsumer<UsersEmployeesCubit, UsersEmployeesStates>(
          listener: (context, state) {
            if (state is DeleteUsersEmployeesFailState) {
              showToastificationWidget(
                message: state.message,
                context: context,
              );
            } else if (state is DeleteUsersEmployeesSuccessState) {
              context.pop();
              showToastificationWidget(
                context: context,
                message: "deleted_successfully".tr(),
                notificationType: ToastificationType.success,
              );
              cubit.getUsersEmployees();
            }
          },
          builder: (context, state) {
            if (state is DeleteUsersEmployeesLoadingState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const EmitLoadingItemNoCenter(size: 20),
              );
            }
            return TextButton(
              onPressed: () {
                cubit.deleteUsersEmployees(id: id);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomText(
                  text: "delete".tr(),
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
