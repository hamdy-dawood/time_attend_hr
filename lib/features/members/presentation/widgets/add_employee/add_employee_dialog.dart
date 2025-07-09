import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';

import '../../../domain/entities/employees_entity.dart';
import '../../cubit/employees_cubit.dart';
import 'choose_image.dart';
import 'confirm_button.dart';
import 'text_fields.dart';

class AddEmployeeDialog extends StatelessWidget {
  const AddEmployeeDialog({super.key, this.member, this.isEdit = false, required this.membersCubit});

  final EmployeesCubit membersCubit;
  final EmployeesEntity? member;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<EmployeesCubit>()),
      ],
      child: AddEmployeeDialogBody(member: member, isEdit: isEdit, membersCubit: membersCubit),
    );
  }
}

class AddEmployeeDialogBody extends StatefulWidget {
  const AddEmployeeDialogBody({super.key, this.member, required this.isEdit, required this.membersCubit});

  final EmployeesCubit membersCubit;
  final EmployeesEntity? member;
  final bool isEdit;

  @override
  State<AddEmployeeDialogBody> createState() => _AddEmployeeDialogBodyState();
}

class _AddEmployeeDialogBodyState extends State<AddEmployeeDialogBody> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<EmployeesCubit>();

    if (widget.isEdit) {
      cubit.nameController.text = widget.member!.displayName;
      cubit.employeeImage = null;
      cubit.template = widget.member!.faceId ?? {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<EmployeesCubit>().employeesFormKey,
      child: Column(
        children: [
          if (context.screenWidth >= 1200)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomText(
                    text: widget.isEdit ? "تعديل الموظف ${widget.member!.displayName}" : "اضافة موظف",
                    color: AppColors.black2,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    maxLines: 3,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    ImageManager.cancelCircle,
                    height: 30,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        text: "البيانات الشخصية :",
                        color: AppColors.black2,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ChooseImage(isEdit: widget.isEdit, member: widget.member),
                const SizedBox(height: 20),
                EmployeeNameTextField(cubit: context.read<EmployeesCubit>()),
                const SizedBox(height: 30),
                ConfirmButton(isEdit: widget.isEdit, membersCubit: widget.membersCubit, member: widget.member),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
