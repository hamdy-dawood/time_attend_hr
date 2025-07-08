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
import 'package:time_attend_recognition/features/members/presentation/cubit/employees_cubit.dart';

import '../../home/presentation/cubit/home_cubit.dart';
import '../../members/presentation/cubit/employees_states.dart';
import 'face_recognition_view.dart';

class ChooseProjectScreen extends StatelessWidget {
  const ChooseProjectScreen({super.key, required this.enrollId});

  final String enrollId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<EmployeesCubit>()),
      ],
      child: ChooseProjectBody(enrollId: enrollId),
    );
  }
}

class ChooseProjectBody extends StatefulWidget {
  const ChooseProjectBody({super.key, required this.enrollId});

  final String enrollId;

  @override
  State<ChooseProjectBody> createState() => _ChooseProjectBodyState();
}

class _ChooseProjectBodyState extends State<ChooseProjectBody> {
  @override
  void initState() {
    context.read<EmployeesCubit>().getSubjects(enrollId: widget.enrollId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");

    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.only(
          right: 15,
          left: 15,
          top: 40,
        ),
        child: ProjectsBodyWidgets(),
      ),
    );
  }
}

class ProjectsBodyWidgets extends StatelessWidget {
  const ProjectsBodyWidgets({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                ImageManager.cancelBack,
                height: 28,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: CustomText(
                text: "اختر المادة",
                color: AppColors.black2,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ],
        ),
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

              return ListView.separated(
                itemCount: cubit.subjectsList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      cubit.updateSubjectSelected(
                        subjectEntity: cubit.subjectsList[index],
                      );
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: cubit.subjectsList[index].code == cubit.selectedSubjectCode ? AppColors.blue : AppColors.grey),
                      ),
                      child: Center(
                        child: CustomText(
                          text: cubit.subjectsList[index].name,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<EmployeesCubit, EmployeesStates>(
          builder: (context, state) {
            return context.read<EmployeesCubit>().selectedSubjectCode != null
                ? CustomButton(
                    onTap: () {
                      MagicRouter.navigateTo(
                        page: FaceRecognitionView(
                          homeCubit: context.read<HomeCubit>(),
                          event: int.parse(context.read<EmployeesCubit>().selectedSubjectCode!),
                          subjectName: context.read<EmployeesCubit>().selectedSubjectName!,
                        ),
                      );
                    },
                    height: 45,
                    borderRadius: 6,
                    color: AppColors.primary,
                    fontColor: Colors.white,
                    text: "التالي",
                  )
                : const SizedBox();
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
