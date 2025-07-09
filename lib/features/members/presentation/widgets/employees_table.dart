import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/emit_failed_item.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/emit_no_data.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

import '../cubit/employees_cubit.dart';
import '../cubit/employees_states.dart';
import 'add_employee/add_employee_dialog.dart';

class EmployeesTable extends StatelessWidget {
  const EmployeesTable({super.key, required this.cubit});

  final EmployeesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesCubit, EmployeesStates>(
      builder: (context, state) {
        if (state is GetEmployeesLoadingState) {
          return const EmitLoadingItem(size: 40);
        } else if (state is GetEmployeesFailState) {
          return EmitFailedItem(text: state.message);
        } else if (state is GetEmployeesNoDataState) {
          return const EmitNoData();
        }

        return LayoutBuilder(
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
              itemCount: cubit.employeesList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 16.w,
                mainAxisExtent: 250,
              ),
              itemBuilder: (context, index) {
                final listData = cubit.employeesList[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border2),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.secondary.withOpacity(0.3),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomText(
                          text: listData.displayName,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          maxLines: 2,
                        ),
                        CustomText(
                          text: listData.enrollId,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                height: 45,
                                borderRadius: 10,
                                isBorderButton: true,
                                borderColor: AppColors.border,
                                color: AppColors.grey2,
                                onTap: () {},
                                widget: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgIcon(
                                      icon: ImageManager.eye,
                                      color: AppColors.grey8,
                                      height: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: CustomText(
                                        text: "عرض",
                                        color: AppColors.grey8,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomButton(
                                height: 45,
                                borderRadius: 10,
                                onTap: () {
                                  if (context.screenWidth < 1200) {
                                    MagicRouter.navigateTo(
                                      page: Scaffold(
                                        backgroundColor: AppColors.white,
                                        appBar: AppBar(
                                          backgroundColor: AppColors.white,
                                          centerTitle: true,
                                          leading: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: SvgPicture.asset(
                                              ImageManager.cancelBack,
                                              height: 28,
                                            ),
                                          ),
                                          title: CustomText(
                                            text: "تعديل الموظف ${listData.displayName}",
                                            color: AppColors.black2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                        body: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: AddEmployeeDialog(
                                            isEdit: true,
                                            member: listData,
                                            membersCubit: cubit,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: AppColors.white,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                          content: Container(
                                            height: 770,
                                            padding: const EdgeInsets.all(20),
                                            width: context.screenWidth * 0.45,
                                            child: AddEmployeeDialog(
                                              isEdit: true,
                                              member: listData,
                                              membersCubit: cubit,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                widget: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgIcon(
                                      icon: ImageManager.editIcon,
                                      color: AppColors.white,
                                      height: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: CustomText(
                                        text: "تعديل",
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
