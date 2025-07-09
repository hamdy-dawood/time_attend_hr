import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:time_attend_recognition/features/members/presentation/cubit/employees_cubit.dart';

import '../../home/presentation/cubit/home_cubit.dart';
import '../../members/data/models/employees_model.dart';
import '../../members/presentation/cubit/employees_states.dart';
import 'face_recognition_view.dart';
import 'manual_attendance.dart';

class ChooseProjectScreen extends StatelessWidget {
  const ChooseProjectScreen({super.key, required this.teacher, required this.manual});

  final EmployeesModel teacher;
  final bool manual;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<EmployeesCubit>()),
      ],
      child: ChooseProjectBody(
        teacher: teacher,
        manual: manual,
      ),
    );
  }
}

class ChooseProjectBody extends StatefulWidget {
  const ChooseProjectBody({super.key, required this.teacher, required this.manual});

  final EmployeesModel teacher;
  final bool manual;

  @override
  State<ChooseProjectBody> createState() => _ChooseProjectBodyState();
}

class _ChooseProjectBodyState extends State<ChooseProjectBody> {
  @override
  void initState() {
    context.read<EmployeesCubit>().getSubjects(enrollId: widget.teacher.enrollId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset(
            ImageManager.cancelBack,
            height: 28,
          ),
        ),
        title: const CustomText(
          text: "اختر المادة",
          color: AppColors.black2,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
        child: ProjectsBodyWidgets(
          teacher: widget.teacher,
          manual: widget.manual,
        ),
      ),
    );
  }
}

class ProjectsBodyWidgets extends StatelessWidget {
  const ProjectsBodyWidgets({super.key, required this.teacher, required this.manual});

  final EmployeesModel teacher;
  final bool manual;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "اختر المادة الدراسية",
              color: AppColors.black,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            const SizedBox(height: 5),
            CustomText(
              text: "مرحبا بك ${teacher.displayName} حدد المادة لبدء تسجيل الحضور",
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(height: 30),
        Expanded(
          child: BlocBuilder<EmployeesCubit, EmployeesStates>(
            builder: (context, state) {
              if (state is GetSubjectsLoadingState) {
                return SizedBox(width: 1.sw, child: const EmitLoadingItem(size: 60));
              } else if (state is GetSubjectsFailState) {
                return EmitFailedItem(text: state.message);
              } else if (state is GetSubjectsNoDataState) {
                return const EmitNoData();
              }

              final cubit = context.read<EmployeesCubit>();

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
                    itemCount: cubit.subjectsList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 16.w,
                      mainAxisExtent: 190,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          cubit.updateSubjectSelected(
                            subjectEntity: cubit.subjectsList[index],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.mainBackground.withOpacity(0.5),
                            border: Border.all(
                              color: cubit.subjectsList[index].code == cubit.selectedSubjectCode ? AppColors.primary : AppColors.border,
                              width: cubit.subjectsList[index].code == cubit.selectedSubjectCode ? 2 : 1,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.green2.withOpacity(0.5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SvgIcon(
                                          icon: ImageManager.subject,
                                          color: AppColors.white,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomText(
                                      text: cubit.subjectsList[index].name,
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 15),
                                    if (cubit.subjectsList[index].code == cubit.selectedSubjectCode)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: CustomButton(
                                          height: 45,
                                          borderRadius: 12,
                                          color: AppColors.primary,
                                          text: "انقر لبدء الحضور",
                                          onTap: () {
                                            if (manual) {
                                              MagicRouter.navigateTo(
                                                page: ManualAttendance(
                                                  homeCubit: context.read<HomeCubit>(),
                                                  event: int.parse(context.read<EmployeesCubit>().selectedSubjectCode!),
                                                  subjectName: context.read<EmployeesCubit>().selectedSubjectName!,
                                                ),
                                              );
                                            } else {
                                              MagicRouter.navigateTo(
                                                page: FaceRecognitionView(
                                                  homeCubit: context.read<HomeCubit>(),
                                                  event: int.parse(context.read<EmployeesCubit>().selectedSubjectCode!),
                                                  subjectName: context.read<EmployeesCubit>().selectedSubjectName!,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (cubit.subjectsList[index].code == cubit.selectedSubjectCode)
                                const Positioned(
                                  top: 0,
                                  left: 8,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: AppColors.green2,
                                  ),
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
          ),
        ),
      ],
    );
  }
}
