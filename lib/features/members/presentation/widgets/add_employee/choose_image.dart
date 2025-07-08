import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_cached_image.dart';
import 'package:time_attend_recognition/core/widget/pick_image_sheet.dart';
import 'package:time_attend_recognition/features/members/domain/entities/employees_entity.dart';

import '../../cubit/employees_cubit.dart';
import '../../cubit/employees_states.dart';

class ChooseImage extends StatelessWidget {
  const ChooseImage({super.key, required this.isEdit, this.member});

  final bool isEdit;
  final EmployeesEntity? member;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<EmployeesCubit, EmployeesStates>(
        builder: (context, state) {
          final cubit = context.read<EmployeesCubit>();

          return Stack(
            children: [
              PickImageWidget(
                title: "اختيار صورة".tr(),
                cubit: cubit,
                onTapOne: () async {
                  cubit.choosePersonImage(
                    source: ImageSource.camera,
                    context: context,
                    editPersonId: isEdit ? member!.id : "",
                  );
                },
                onTapTwo: () {
                  cubit.choosePersonImage(
                    source: ImageSource.gallery,
                    context: context,
                    editPersonId: isEdit ? member!.id : "",
                  );
                },
                child: cubit.employeeImage != null
                    ? ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(60),
                          child: kIsWeb
                              ? Image.network(
                                  cubit.employeeImage!.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(cubit.employeeImage!.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      )
                    : cubit.employeeImageUploaded.isNotEmpty
                        ? ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(60),
                              child: CustomCachedImage(
                                image: cubit.employeeImageUploaded,
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
              ),
              if (isEdit)
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: PickImageWidget(
                    title: "اختيار صورة".tr(),
                    cubit: cubit,
                    onTapOne: () async {
                      cubit.choosePersonImage(
                        source: ImageSource.camera,
                        context: context,
                        editPersonId: isEdit ? member!.id : "",
                      );
                    },
                    onTapTwo: () {
                      cubit.choosePersonImage(
                        source: ImageSource.gallery,
                        context: context,
                        editPersonId: isEdit ? member!.id : "",
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
