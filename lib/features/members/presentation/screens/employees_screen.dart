import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

import '../cubit/employees_cubit.dart';
import '../widgets/employees_table.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeesCubit>()..getEmployees(),
      child: const EmployeesBody(),
    );
  }
}

class EmployeesBody extends StatelessWidget {
  const EmployeesBody({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");

    return const Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Padding(
        padding: EdgeInsets.only(
          right: 15,
          left: 15,
          top: 40,
        ),
        child: EmployeesBodyWidgets(),
      ),
      // floatingActionButton: !kIsWeb
      //     ? Platform.isAndroid || Platform.isIOS
      //         ? context.screenWidth < 800 && Caching.getProfile()!.permissions.canAdd
      //             ? FloatingActionButton(
      //                 backgroundColor: AppColors.primary,
      //                 tooltip: 'اضافة موظف',
      //                 onPressed: () {
      //                   MagicRouter.navigateTo(
      //                     page: Scaffold(
      //                       backgroundColor: AppColors.white,
      //                       appBar: AppBar(
      //                         backgroundColor: AppColors.white,
      //                         centerTitle: true,
      //                         leading: IconButton(
      //                           onPressed: () {
      //                             context.pop();
      //                           },
      //                           icon: SvgPicture.asset(
      //                             ImageManager.cancelBack,
      //                             height: 28,
      //                           ),
      //                         ),
      //                         title: const CustomText(
      //                           text: "اضافة موظف",
      //                           color: AppColors.black2,
      //                           fontWeight: FontWeight.w600,
      //                           fontSize: 22,
      //                         ),
      //                       ),
      //                       body: Padding(
      //                         padding: const EdgeInsets.all(20),
      //                         child: AddEmployeeDialog(membersCubit: context.read<EmployeesCubit>()),
      //                       ),
      //                     ),
      //                   );
      //                 },
      //                 child: const Icon(Icons.add, color: AppColors.white, size: 28),
      //               )
      //             : null
      //         : null
      //     : null,
    );
  }
}

class EmployeesBodyWidgets extends StatelessWidget {
  const EmployeesBodyWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.screenWidth > 800)
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TitleWithBack(),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              context.screenWidth > 1300 ? 0.2.sw : 0.1.sw),
                      child: const _SearchTextField(),
                    ),
                  ),
                  // if (!kIsWeb)
                  //   if (Platform.isAndroid || Platform.isIOS)
                  //     if (Caching.getProfile()!.permissions.canAdd) AddEmployeeButton(cubit: context.read<EmployeesCubit>()),
                ],
              ),
            ],
          )
        else
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleWithBack(),
              SizedBox(height: 10),
              _SearchTextField(),
            ],
          ),
        const SizedBox(height: 15),
        Expanded(child: EmployeesTable(cubit: context.read<EmployeesCubit>())),
      ],
    );
  }
}

class _TitleWithBack extends StatelessWidget {
  const _TitleWithBack();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            text: "إدارة الطلاب",
            color: AppColors.black2,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField();

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      title: "",
      controller: context.read<EmployeesCubit>().searchController,
      borderRadius: 10,
      hintText: "بحث...",
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SvgIcon(
          icon: ImageManager.search,
          color: AppColors.grey4,
          height: 20,
        ),
      ),
      onFieldSubmitted: (value) {
        context.read<EmployeesCubit>().getEmployees();
      },
      maxLines: 1,
      isLastInput: true,
    );
  }
}
