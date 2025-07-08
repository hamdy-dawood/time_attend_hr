import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_data_table.dart';
import 'package:time_attend_recognition/core/widget/custom_drop_item.dart';
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
    return SizedBox(
      width: double.infinity,
      child: context.screenWidth > 600
          ? EmployeesTableBody(cubit: cubit, width: 1.sw)
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: EmployeesTableBody(cubit: cubit),
            ),
    );
  }
}

class EmployeesTableBody extends StatelessWidget {
  const EmployeesTableBody({super.key, required this.cubit, this.width});

  final EmployeesCubit cubit;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesCubit, EmployeesStates>(
      builder: (context, state) {
        if (state is GetEmployeesLoadingState) {
          return SizedBox(width: 1.sw, child: const EmitLoadingItem(size: 60));
        } else if (state is GetEmployeesFailState) {
          return EmitFailedItem(text: state.message);
        } else if (state is GetEmployeesNoDataState) {
          return const EmitNoData();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DataTable(
                    dividerThickness: 0.6,
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: double.infinity,
                    headingRowColor: WidgetStateProperty.all(AppColors.grey2.withOpacity(0.5)),
                    dataRowColor: WidgetStateProperty.all(AppColors.white),
                    border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(12)),
                    columns: [
                      customDataColumn("#"),
                      // customDataColumn("صورة الموظف"),
                      customDataColumn("اسم الموظف"),
                      customDataColumn("الاجراء"),
                    ],
                    rows: List.generate(
                      cubit.employeesList.length,
                      (index) {
                        final listData = cubit.employeesList[index];
                        return DataRow(
                          cells: [
                            customDataCell("${index + 1}"),
                            // customDataCell(
                            //   "",
                            //   isWidget: true,
                            //   widget: Padding(
                            //     padding: const EdgeInsets.symmetric(vertical: 5),
                            //     child: ClipOval(
                            //       child: SizedBox.fromSize(
                            //         size: const Size.fromRadius(30),
                            //         child: CustomCachedImage(
                            //           image: listData.image,
                            //           fit: BoxFit.cover,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            customDataCell(listData.displayName),
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
                                                    text: "تعديل الموظف ${listData.displayName}",
                                                    color: AppColors.black2,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22,
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
                                        child: CustomDropItem(
                                          icon: ImageManager.edit,
                                          title: "edit".tr(),
                                          iconColor: AppColors.black,
                                          textColor: AppColors.black,
                                        ),
                                      ),
                                      // PopupMenuItem(
                                      //   onTap: () {
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (context) {
                                      //         return DeleteEmployeesAlert(
                                      //           cubit: cubit,
                                      //           id: listData.id,
                                      //           name: listData.displayName,
                                      //         );
                                      //       },
                                      //     );
                                      //   },
                                      //   child: CustomDropItem(
                                      //     icon: ImageManager.delete,
                                      //     title: "delete".tr(),
                                      //     textColor: AppColors.red,
                                      //     iconColor: AppColors.red,
                                      //   ),
                                      // ),
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
              const SizedBox(height: 20),
              // const _BuildPagesCount(),
            ],
          ),
        );
      },
    );
  }
}

// class _BuildPagesCount extends StatelessWidget {
//   const _BuildPagesCount();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EmployeesCubit, EmployeesStates>(
//       builder: (context, state) {
//         if (state is GetEmployeesLoadingState) {
//           return const EmitLoadingItem(size: 60);
//         }
//         return calculatePageNumber(context.read<EmployeesCubit>().count) > 1
//             ? Padding(
//                 padding: const EdgeInsets.only(top: 20, bottom: 30),
//                 child: CustomPaginationTable(
//                   onTapNumber: (page) {
//                     context.read<EmployeesCubit>().page = page;
//                     context.read<EmployeesCubit>().getCount(resetPage: false);
//                   },
//                   pagesCount: calculatePageNumber(context.read<EmployeesCubit>().count),
//                   currentPage: context.read<EmployeesCubit>().page,
//                   onTapNext: () {
//                     context.read<EmployeesCubit>().page++;
//                     context.read<EmployeesCubit>().getCount(resetPage: false);
//                   },
//                   onTapPrevious: () {
//                     context.read<EmployeesCubit>().page--;
//                     context.read<EmployeesCubit>().getCount(resetPage: false);
//                   },
//                 ),
//               )
//             : const SizedBox();
//       },
//     );
//   }
// }
