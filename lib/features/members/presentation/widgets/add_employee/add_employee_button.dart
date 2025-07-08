import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';

import '../../cubit/employees_cubit.dart';
import 'add_employee_dialog.dart';

class AddEmployeeButton extends StatelessWidget {
  const AddEmployeeButton({super.key, required this.cubit});

  final EmployeesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: AddEmployeeButtonBody(cubit: cubit),
    );
  }
}

class AddEmployeeButtonBody extends StatelessWidget {
  const AddEmployeeButtonBody({super.key, required this.cubit});

  final EmployeesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
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
                title: const CustomText(
                  text: "اضافة موظف",
                  color: AppColors.black2,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: AddEmployeeDialog(membersCubit: cubit),
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
                  child: AddEmployeeDialog(membersCubit: cubit),
                ),
              );
            },
          );
        }
      },
      height: 45,
      width: 200,
      borderRadius: 6,
      color: AppColors.primary,
      fontColor: Colors.white,
      widget: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIcon(
              icon: ImageManager.add,
              color: Colors.white,
              height: 16,
            ),
            SizedBox(width: 15),
            CustomText(
              text: "اضافة موظف",
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
