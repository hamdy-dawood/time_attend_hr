import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_cached_image.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/pick_image_sheet.dart';
import 'package:time_attend_recognition/core/widget/row_text_with_switch.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:time_attend_recognition/features/users/domain/entities/users_employees_entity.dart';
import 'package:toastification/toastification.dart';

import '../cubit/users_cubit.dart';
import '../cubit/users_states.dart';

class AddUsersEmployeesDialog extends StatelessWidget {
  const AddUsersEmployeesDialog({super.key, this.usersEmployee, this.isEdit = false, required this.usersEmployeesCubit});

  final UsersEmployeesCubit usersEmployeesCubit;
  final UsersEmployeesEntity? usersEmployee;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UsersEmployeesCubit>(),
      child: AddUsersEmployeesDialogBody(usersEmployee: usersEmployee, isEdit: isEdit, usersEmployeesCubit: usersEmployeesCubit),
    );
  }
}

class AddUsersEmployeesDialogBody extends StatefulWidget {
  const AddUsersEmployeesDialogBody({super.key, this.usersEmployee, required this.isEdit, required this.usersEmployeesCubit});

  final UsersEmployeesCubit usersEmployeesCubit;
  final UsersEmployeesEntity? usersEmployee;
  final bool isEdit;

  @override
  State<AddUsersEmployeesDialogBody> createState() => _AddUsersEmployeesDialogBodyState();
}

class _AddUsersEmployeesDialogBodyState extends State<AddUsersEmployeesDialogBody> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UsersEmployeesCubit>();

    if (widget.isEdit) {
      cubit.nameController.text = widget.usersEmployee!.displayName;
      cubit.usernameController.text = widget.usersEmployee!.username;
      cubit.usersEmployeeImageUploaded = widget.usersEmployee!.image;
      cubit.passwordController.text = "******";
      cubit.showEmployeesPage = widget.usersEmployee!.permissions.showEmployeesPage;
      cubit.showAttendanceReportPage = widget.usersEmployee!.permissions.showAttendanceReportPage;
      cubit.showAttendancePage = widget.usersEmployee!.permissions.showAttendancePage;
      cubit.showFullReportPage = widget.usersEmployee!.permissions.showFullReportPage;
      cubit.showProjectsPage = widget.usersEmployee!.permissions.showProjectsPage;
      cubit.showHolidaysPage = widget.usersEmployee!.permissions.showHolidaysPage;
      cubit.canRecognize = widget.usersEmployee!.permissions.canRecognize;
      cubit.canAdd = widget.usersEmployee!.permissions.canAdd;
      cubit.canEdit = widget.usersEmployee!.permissions.canEdit;
      cubit.canDelete = widget.usersEmployee!.permissions.canDelete;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<UsersEmployeesCubit>().usersEmployeesFormKey,
      child: Column(
        children: [
          if (context.screenWidth >= 1200)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomText(
                    text: widget.isEdit ? "تعديل المستخدم ${widget.usersEmployee!.displayName}" : "اضافة مستخدم",
                    color: AppColors.black2,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: BlocConsumer<UsersEmployeesCubit, UsersEmployeesStates>(
                      listener: (context, state) {
                        if (state is PickedImageState) {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        final cubit = context.read<UsersEmployeesCubit>();

                        return PickImageWidget(
                          title: "اختيار صورة".tr(),
                          cubit: cubit,
                          onTapOne: () {
                            cubit.pickMemberImageFile(
                              source: ImageSource.camera,
                              context: context,
                            );
                          },
                          onTapTwo: () {
                            cubit.pickMemberImageFile(
                              source: ImageSource.gallery,
                              context: context,
                            );
                          },
                          child: cubit.usersEmployeeImageUploaded.isNotEmpty
                              ? ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(60),
                                    child: CustomCachedImage(
                                      image: cubit.usersEmployeeImageUploaded,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : cubit.usersEmployeeImage != null
                                  ? ClipOval(
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(60),
                                        child: Image.network(
                                          cubit.usersEmployeeImage!.path,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundColor: AppColors.secondary.withOpacity(0.3),
                                      child: const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextFormField(
                          title: "الاسم *",
                          titleFontSize: 16,
                          titleFontWeight: FontWeight.w500,
                          titleColor: AppColors.grey,
                          controller: context.read<UsersEmployeesCubit>().nameController,
                          borderRadius: 6,
                          hintText: "الاسم",
                          filledColor: AppColors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ادخل الاسم !";
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: CustomTextFormField(
                          title: "اسم المستخدم *",
                          titleFontSize: 16,
                          titleFontWeight: FontWeight.w500,
                          titleColor: AppColors.grey,
                          controller: context.read<UsersEmployeesCubit>().usernameController,
                          borderRadius: 6,
                          hintText: "اسم المستخدم",
                          filledColor: AppColors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ادخل اسم المستخدم !";
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<UsersEmployeesCubit, UsersEmployeesStates>(
                    builder: (context, state) {
                      final cubit = context.read<UsersEmployeesCubit>();
                      return AbsorbPointer(
                        absorbing: widget.isEdit ? true : false,
                        child: CustomTextFormField(
                          title: "كلمة المرور *",
                          titleFontSize: 16,
                          titleFontWeight: FontWeight.w500,
                          titleColor: AppColors.grey,
                          controller: cubit.passwordController,
                          borderRadius: 6,
                          hintText: "كلمة المرور",
                          filledColor: AppColors.white,
                          maxLines: 1,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              cubit.usersEmployeeVisibility();
                            },
                            child: Icon(
                              cubit.usersEmployeePasswordObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.grey4,
                            ),
                          ),
                          obscureText: cubit.usersEmployeePasswordObscure,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "ادخل كلمة المرور !";
                            }

                            return null;
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BlocBuilder<UsersEmployeesCubit, UsersEmployeesStates>(
                      builder: (context, state) {
                        final cubit = context.read<UsersEmployeesCubit>();

                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            RowTextWithSwitch(
                              bodyText: "شاشة الموظفين",
                              switchValue: cubit.showEmployeesPage,
                              onChanged: (value) {
                                cubit.changeShowEmployees();
                              },
                            ),
                            // RowTextWithSwitch(
                            //   bodyText: "شاشة الحضور",
                            //   switchValue: cubit.showAttendancePage,
                            //   onChanged: (value) {
                            //     cubit.changeShowAttendance();
                            //   },
                            // ),
                            RowTextWithSwitch(
                              bodyText: "شاشة تقرير الحضور",
                              switchValue: cubit.showAttendanceReportPage,
                              onChanged: (value) {
                                cubit.changeShowAttendanceReportPage();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "شاشة التقرير الشامل",
                              switchValue: cubit.showFullReportPage,
                              onChanged: (value) {
                                cubit.changeShowFullReport();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "شاشة المشاريع",
                              switchValue: cubit.showProjectsPage,
                              onChanged: (value) {
                                cubit.changeShowProjects();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "شاشة الاجازات",
                              switchValue: cubit.showHolidaysPage,
                              onChanged: (value) {
                                cubit.changeShowHolidays();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "امكانية التعرف",
                              switchValue: cubit.canRecognize,
                              onChanged: (value) {
                                cubit.changeCanRecognize();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "امكانية الاضافة",
                              switchValue: cubit.canAdd,
                              onChanged: (value) {
                                cubit.changeCanAdd();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "امكانية التعديل",
                              switchValue: cubit.canEdit,
                              onChanged: (value) {
                                cubit.changeCanEdit();
                              },
                            ),
                            RowTextWithSwitch(
                              bodyText: "امكانية الحذف",
                              switchValue: cubit.canDelete,
                              onChanged: (value) {
                                cubit.changeCanDelete();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<UsersEmployeesCubit, UsersEmployeesStates>(
                    listener: (context, state) {
                      if (state is AddUsersEmployeesSuccessState) {
                        Navigator.pop(context);
                        showToastificationWidget(
                          message: widget.isEdit ? "edit_successfully".tr() : "add_successfully".tr(),
                          context: context,
                          notificationType: ToastificationType.success,
                        );
                        widget.usersEmployeesCubit.getUsersEmployees();
                      } else if (state is AddUsersEmployeesFailState) {
                        showToastificationWidget(
                          message: state.message,
                          context: context,
                        );
                      }
                    },
                    builder: (context, state) {
                      final cubit = context.read<UsersEmployeesCubit>();

                      if (state is AddUsersEmployeesLoadingState) {
                        return const EmitLoadingItem(color: AppColors.primary);
                      }
                      return CustomButton(
                        onTap: () {
                          widget.isEdit ? cubit.editUsersEmployees(id: widget.usersEmployee!.id) : cubit.addUsersEmployees();
                        },
                        height: 48,
                        borderRadius: 6,
                        color: AppColors.primary,
                        fontColor: Colors.white,
                        text: widget.isEdit ? "تعديل" : "اضافة",
                        fontSize: 18,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
