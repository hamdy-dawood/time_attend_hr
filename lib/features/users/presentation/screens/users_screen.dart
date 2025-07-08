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

import '../cubit/users_cubit.dart';
import '../widgets/add_users_employee_button.dart';
import '../widgets/users_employees_table.dart';

class UsersEmployeesScreen extends StatelessWidget {
  const UsersEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UsersEmployeesCubit>()..getCount(),
      child: const UsersEmployeesBody(),
    );
  }
}

class UsersEmployeesBody extends StatelessWidget {
  const UsersEmployeesBody({super.key});

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
        child: UsersEmployeesBodyWidgets(),
      ),
    );
  }
}

class UsersEmployeesBodyWidgets extends StatelessWidget {
  const UsersEmployeesBodyWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.screenWidth > 650)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _TitleWithBack(),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.screenWidth > 1000 ? 0.2.sw : 0.1.sw),
                  child: const _SearchTextField(),
                ),
              ),
              AddUsersEmployeeButton(cubit: context.read<UsersEmployeesCubit>()),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TitleWithBack(),
              const SizedBox(height: 10),
              const _SearchTextField(),
              const SizedBox(height: 10),
              AddUsersEmployeeButton(cubit: context.read<UsersEmployeesCubit>()),
            ],
          ),
        const SizedBox(height: 30),
        Expanded(child: UsersEmployeesTable(cubit: context.read<UsersEmployeesCubit>())),
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
        const CustomText(
          text: "المستخدمين",
          color: AppColors.black2,
          fontWeight: FontWeight.w600,
          fontSize: 24,
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
      controller: context.read<UsersEmployeesCubit>().searchController,
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
        context.read<UsersEmployeesCubit>().getUsersEmployees();
      },
    );
  }
}
