import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_data_table.dart';
import 'package:time_attend_recognition/core/widget/custom_drop_item.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/emit_failed_item.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/emit_no_data.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';
import 'package:time_attend_recognition/core/widget/table_pagination_container.dart';

import '../cubit/users_cubit.dart';
import '../cubit/users_states.dart';
import 'add_users_employee_dialog.dart';
import 'delete_users_employee_alert.dart';

class UsersEmployeesTable extends StatelessWidget {
  const UsersEmployeesTable({super.key, required this.cubit});

  final UsersEmployeesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: context.screenWidth > 1070
          ? UsersEmployeesTableBody(cubit: cubit, width: 1.sw)
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: UsersEmployeesTableBody(cubit: cubit),
            ),
    );
  }
}

class UsersEmployeesTableBody extends StatelessWidget {
  const UsersEmployeesTableBody({super.key, required this.cubit, this.width});

  final UsersEmployeesCubit cubit;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersEmployeesCubit, UsersEmployeesStates>(
      builder: (context, state) {
        if (state is GetUsersEmployeesLoadingState) {
          return const EmitLoadingItem(size: 60);
        } else if (state is GetUsersEmployeesFailState) {
          return EmitFailedItem(text: state.message);
        } else if (state is GetUsersEmployeesNoDataState) {
          return const EmitNoData();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DataTable(
                    dividerThickness: 0.6,
                    dataRowMaxHeight: double.infinity,
                    headingRowColor: WidgetStateProperty.all(AppColors.grey2.withOpacity(0.5)),
                    dataRowColor: WidgetStateProperty.all(AppColors.white),
                    border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(12)),
                    columns: [
                      customDataColumn("#"),
                      customDataColumn("الاسم"),
                      customDataColumn("اسم المستخدم"),
                      customDataColumn("الموقع"),
                      customDataColumn("الاجراء"),
                    ],
                    rows: List.generate(
                      cubit.usersEmployeesList.length,
                      (index) {
                        return DataRow(
                          cells: [
                            customDataCell("${index + 1}"),
                            customDataCell(cubit.usersEmployeesList[index].displayName),
                            customDataCell(cubit.usersEmployeesList[index].username),
                            customDataCell(cubit.usersEmployeesList[index].timezone),
                            DataCell(
                              Center(
                                child: PopupMenuButton(
                                  color: Colors.white,
                                  initialValue: -1,
                                  position: PopupMenuPosition.under,
                                  tooltip: "",
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
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
                                                    text: "تعديل المستخدم ${cubit.usersEmployeesList[index].displayName}",
                                                    color: AppColors.black2,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                                body: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: AddUsersEmployeesDialog(
                                                    isEdit: true,
                                                    usersEmployee: cubit.usersEmployeesList[index],
                                                    usersEmployeesCubit: cubit,
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
                                                    height: 760,
                                                    padding: const EdgeInsets.all(20),
                                                    width: context.screenWidth * 0.51,
                                                    child: AddUsersEmployeesDialog(
                                                      isEdit: true,
                                                      usersEmployee: cubit.usersEmployeesList[index],
                                                      usersEmployeesCubit: cubit,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: CustomDropItem(
                                          icon: ImageManager.edit,
                                          title: "edit".tr(),
                                          iconColor: AppColors.black,
                                          textColor: AppColors.black,
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteUsersEmployeesAlert(
                                                cubit: cubit,
                                                id: cubit.usersEmployeesList[index].id,
                                                name: cubit.usersEmployeesList[index].displayName,
                                              );
                                            },
                                          );
                                        },
                                        child: CustomDropItem(
                                          icon: ImageManager.delete,
                                          title: "delete".tr(),
                                          textColor: AppColors.black,
                                          iconColor: AppColors.red,
                                        ),
                                      ),
                                    ];
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SvgIcon(
                                      icon: ImageManager.dots,
                                      color: AppColors.black3,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const _BuildPagesCount(),
            ],
          ),
        );
      },
    );
  }
}

class _BuildPagesCount extends StatelessWidget {
  const _BuildPagesCount();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersEmployeesCubit, UsersEmployeesStates>(
      builder: (context, state) {
        if (state is GetUsersEmployeesLoadingState) {
          return const EmitLoadingItem(size: 60);
        }
        return calculatePageNumber(context.read<UsersEmployeesCubit>().count) > 1
            ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    calculatePageNumber(context.read<UsersEmployeesCubit>().count),
                    (index) {
                      return TablePaginationContainer(
                        onTap: () {
                          context.read<UsersEmployeesCubit>().page = index;
                          context.read<UsersEmployeesCubit>().getUsersEmployees();
                        },
                        number: "${index + 1}",
                      );
                    },
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
