import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/emit_failed_item.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/emit_no_data.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';
import 'package:time_attend_recognition/features/members/presentation/cubit/employees_cubit.dart';

import '../../home/presentation/cubit/home_cubit.dart';
import '../../members/presentation/cubit/employees_states.dart';
import 'finish_recognition_view.dart';

class ManualAttendance extends StatelessWidget {
  const ManualAttendance({super.key, required this.homeCubit, required this.subjectName, required this.event});

  final HomeCubit homeCubit;
  final String subjectName;
  final int event;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<EmployeesCubit>()..getEmployees()),
      ],
      child: ManualAttendanceBody(
        homeCubit: homeCubit,
        subjectName: subjectName,
        event: event,
      ),
    );
  }
}

class ManualAttendanceBody extends StatelessWidget {
  const ManualAttendanceBody({super.key, required this.homeCubit, required this.subjectName, required this.event});

  final HomeCubit homeCubit;
  final String subjectName;
  final int event;

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");
    context.read<EmployeesCubit>().pageController = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: const SizedBox(),
        title: CustomText(
          text: " مادة $subjectName",
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: CustomText(
                text: "تسجيل حضور الطلاب يدويا",
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20,
                textAlign: TextAlign.center,
                maxLines: 10,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SelectEmployeesDataMobile(
          homeCubit: homeCubit,
          subjectName: subjectName,
          event: event,
        ),
      ),
      /*  floatingActionButton: BlocBuilder<EmployeesCubit, EmployeesStates>(
        builder: (context, state) {
          return context.read<EmployeesCubit>().selectedEmployees.isNotEmpty
              ? _ContinueButton(
                  employees: context.read<EmployeesCubit>().selectedEmployees,
                  homeCubit: homeCubit,
                  subjectName: subjectName,
                  event: event,
                )
              : const SizedBox();
        },
      ),*/
    );
  }
}

class SelectEmployeesDataMobile extends StatelessWidget {
  const SelectEmployeesDataMobile({super.key, required this.homeCubit, required this.subjectName, required this.event});

  final HomeCubit homeCubit;
  final String subjectName;
  final int event;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmployeesCubit>();
    return BlocBuilder<EmployeesCubit, EmployeesStates>(
      builder: (context, state) {
        if (state is GetEmployeesLoadingState) {
          return const EmitLoadingItem(size: 40);
        } else if (state is GetEmployeesFailState) {
          return EmitFailedItem(text: state.message);
        } else if (state is GetEmployeesNoDataState) {
          return const EmitNoData();
        }

        return PageView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          controller: cubit.pageController,
          itemCount: cubit.employeesList.length,
          itemBuilder: (context, index) {
            final employee = cubit.employeesList[index];

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.secondary.withOpacity(0.3),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text: employee.displayName,
                    color: AppColors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 5),
                  CustomText(
                    text: employee.enrollId,
                    color: AppColors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 20),
                  if (cubit.selectedEmployees.contains(employee))
                    Builder(
                      builder: (context) {
                        bool isAttend = cubit.attendSelectedEmployees.contains(employee);
                        bool isAbsent = cubit.absentSelectedEmployees.contains(employee);

                        String statusText = "";
                        if (isAttend) {
                          statusText = "حاضر";
                        } else if (isAbsent) {
                          statusText = "غائب";
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: CustomButton(
                            height: 40,
                            width: 80,
                            borderRadius: 6,
                            fontSize: 18,
                            color: isAttend ? AppColors.green : AppColors.red,
                            onTap: () {},
                            text: statusText,
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 45,
                            borderRadius: 10,
                            color: AppColors.green,
                            onTap: () {
                              cubit.attendEmployeeSelection(employee.id);
                            },
                            widget: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgIcon(
                                  icon: ImageManager.active,
                                  color: AppColors.white,
                                  height: 18,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: CustomText(
                                    text: "حضور",
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
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
                            isBorderButton: true,
                            borderColor: AppColors.red,
                            color: AppColors.white,
                            onTap: () {
                              cubit.absentEmployeeSelection(employee.id);
                            },
                            widget: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgIcon(
                                  icon: ImageManager.removePerson,
                                  color: AppColors.red,
                                  height: 18,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: CustomText(
                                    text: "غياب",
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        height: 40,
                        width: 100,
                        borderRadius: 10,
                        isBorderButton: true,
                        borderColor: AppColors.grey2,
                        color: AppColors.white,
                        onTap: () {
                          final currentPage = cubit.pageController.page?.round() ?? 0;
                          if (currentPage > 0) {
                            cubit.pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        widget: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIcon(
                              icon: ImageManager.rightArrow,
                              color: AppColors.grey,
                              height: 16,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: CustomText(
                                text: "السابق",
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        height: 40,
                        width: 100,
                        borderRadius: 10,
                        isBorderButton: true,
                        borderColor: AppColors.grey2,
                        color: AppColors.white,
                        onTap: () {
                          final currentPage = cubit.pageController.page?.round() ?? 0;
                          if (currentPage < cubit.employeesList.length - 1) {
                            cubit.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        widget: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIcon(
                              icon: ImageManager.leftArrow,
                              color: AppColors.grey,
                              height: 16,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: CustomText(
                                text: "التالي",
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  BlocConsumer<HomeCubit, HomeStates>(
                    listener: (context, state) {
                      if (state is MakeFingerprintFailState) {
                        showToastificationWidget(
                          message: state.message,
                          context: context,
                        );
                      } else if (state is MakeFingerprintSuccessState) {
                        MagicRouter.navigateTo(
                          page: const FinishFaceRecognitionView(),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is MakeFingerprintLoadingState) {
                        return const EmitLoadingItem(size: 40, color: AppColors.green);
                      }

                      return CustomButton(
                        height: 48,
                        borderRadius: 10,
                        color: AppColors.red,
                        onTap: () {
                          homeCubit.fingerprintSelectedStudents(
                            employees: cubit.attendSelectedEmployees,
                            event: event,
                          );
                        },
                        widget: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIcon(
                              icon: ImageManager.minusCircle,
                              color: AppColors.white,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            CustomText(
                              text: "انهاء الجلسة",
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/*class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.homeCubit, required this.subjectName, required this.event, required this.employees});

  final HomeCubit homeCubit;
  final String subjectName;
  final int event;
  final List<EmployeesEntity> employees;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is MakeFingerprintFailState) {
          showToastificationWidget(
            message: state.message,
            context: context,
          );
        } else if (state is MakeFingerprintSuccessState) {
          MagicRouter.navigateTo(
            page: const HomeScreen(getAllEmployees: false),
            withHistory: false,
          );
          showToastificationWidget(
            context: context,
            message: "تم تسجيل الحضور بنجاح",
            notificationType: ToastificationType.success,
          );
        }
      },
      builder: (context, state) {
        if (state is MakeFingerprintLoadingState) {
          return const SizedBox(
            height: 50,
            width: 180,
            child: EmitLoadingItem(size: 40, color: AppColors.green),
          );
        }
        return SizedBox(
          height: 45,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: AppColors.green,
            onPressed: () {
              homeCubit.fingerprintSelectedStudents(
                employees: employees,
                event: event,
              );
            },
            label: CustomText(
              text: "تسجيل الحضور".tr(),
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}*/
