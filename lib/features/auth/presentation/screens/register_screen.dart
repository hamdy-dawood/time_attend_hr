import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:time_attend_recognition/features/auth/presentation/cubit/register/register_states.dart';

import '../cubit/register/register_cubit.dart';
import '../widgets/register_username_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");

    return BlocProvider(
      create: (context) => getIt<RegisterCubit>(),
      child: const RegisterBody(),
    );
  }
}

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Image.asset(
            ImageManager.homeBg,
            height: 1.sh,
            width: 1.sw,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                    padding: const EdgeInsetsDirectional.all(20),
                    width: 500,
                    decoration: BoxDecoration(
                      color: AppColors.grey13,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border2),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: SvgPicture.asset(
                                    ImageManager.cancelBack,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Flexible(
                                  child: CustomText(
                                    text: "KYP-HR",
                                    color: AppColors.primary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const CustomText(
                              text: "انشاء حساب جديد",
                              color: AppColors.black3,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              title: "الاسم",
                              controller: cubit.companyNameController,
                              filledColor: AppColors.white,
                              titleColor: AppColors.grey8,
                              titleFontSize: 15,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "من فضلك ادخل الاسم !";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            UsernameTextField(cubit: cubit),
                            const SizedBox(height: 10),
                            BlocBuilder<RegisterCubit, RegisterStates>(
                              builder: (context, state) {
                                return CustomTextFormField(
                                  title: "كلمة المرور".tr(),
                                  controller: cubit.passwordController,
                                  filledColor: AppColors.white,
                                  titleColor: AppColors.grey8,
                                  titleFontSize: 15,
                                  maxLines: 1,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      cubit.changeVisibility();
                                    },
                                    icon: Icon(
                                      cubit.isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  obscureText: cubit.isObscure,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "من فضلك ادخل كلمة المرور !";
                                    }
                                    return null;
                                  },
                                  isLastInput: true,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocConsumer<RegisterCubit, RegisterStates>(
                              listener: (context, state) {
                                if (state is RegisterSuccessState) {
                                  context.pushNamedAndRemoveUntil(
                                    Routes.home,
                                    predicate: (Route<dynamic> route) => false,
                                  );
                                } else if (state is RegisterFailState) {
                                  showToastificationWidget(
                                    message: state.message,
                                    context: context,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is RegisterLoadingState) {
                                  return const EmitLoadingItem();
                                }
                                return CustomButton(
                                  height: 50,
                                  borderRadius: 10,
                                  text: "انشاء حساب".tr(),
                                  onTap: () {
                                    cubit.register();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
