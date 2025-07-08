import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';

import '../cubit/register/register_cubit.dart';
import '../cubit/register/register_states.dart';

class UsernameTextField extends StatefulWidget {
  const UsernameTextField({super.key, required this.cubit});

  final RegisterCubit cubit;

  @override
  State<UsernameTextField> createState() => UsernameTextFieldState();
}

class UsernameTextFieldState extends State<UsernameTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (widget.cubit.userNameController.text.isNotEmpty) {
          widget.cubit.checkUsername();
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterStates>(
      builder: (context, state) {
        return CustomTextFormField(
          focusNode: _focusNode,
          controller: widget.cubit.userNameController,
          title: "اسم المستخدم",
          hintText: "",
          errorFontSize: widget.cubit.userNameController.text.isEmpty ? 0 : 12,
          filledColor: AppColors.white,
          validator: (value) {
            if (value!.isEmpty) {
              return "من فضلك ادخل اسم المستخدم";
            } else if (widget.cubit.isUsernameAvailable == false) {
              return "اسم المستخدم مستخدم من قبل";
            }
            return null;
          },
          suffixIcon: BlocBuilder<RegisterCubit, RegisterStates>(
            buildWhen: (previous, current) => current is CheckUserLoadingState || current is CheckUserSuccessState,
            builder: (context, state) {
              if (state is CheckUserLoadingState) {
                return const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: EmitLoadingItemNoCenter(size: 10),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}
