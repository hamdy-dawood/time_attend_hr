// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:time_attend_recognition/core/helper/extension.dart';
// import 'package:time_attend_recognition/core/routing/routes.dart';
// import 'package:time_attend_recognition/core/utils/colors.dart';
// import 'package:time_attend_recognition/core/utils/image_manager.dart';
// import 'package:time_attend_recognition/core/widget/custom_button.dart';
// import 'package:time_attend_recognition/core/widget/custom_text.dart';
// import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
// import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
// import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
// import 'package:toastification/toastification.dart';
//
// import '../cubit/home_cubit.dart';
// import '../cubit/home_states.dart';
//
// class ChangePasswordAlert extends StatefulWidget {
//   const ChangePasswordAlert({super.key, required this.cubit});
//
//   final HomeCubit cubit;
//
//   @override
//   State<ChangePasswordAlert> createState() => _ChangePasswordAlertState();
// }
//
// class _ChangePasswordAlertState extends State<ChangePasswordAlert> {
//   @override
//   void initState() {
//     widget.cubit.oldPasswordController.clear();
//     widget.cubit.newPasswordController.clear();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: AppColors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
//       content: SizedBox(
//         width: context.screenWidth * 0.45,
//         child: Form(
//           key: widget.cubit.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Flexible(
//                     child: CustomText(
//                       text: "تغيير كلمة المرور",
//                       color: AppColors.black2,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 24,
//                       maxLines: 3,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Image.asset(
//                       ImageManager.cancelCircle,
//                       height: 30,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               BlocBuilder<HomeCubit, HomeStates>(
//                 builder: (context, state) {
//                   return CustomTextFormField(
//                     title: "كلمة المرور القديمة",
//                     controller: widget.cubit.oldPasswordController,
//                     filledColor: AppColors.white,
//                     titleColor: AppColors.grey8,
//                     titleFontSize: 15,
//                     maxLines: 1,
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         widget.cubit.changeOldVisibility();
//                       },
//                       icon: Icon(
//                         widget.cubit.isOldObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                     obscureText: widget.cubit.isOldObscure,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "من فضلك ادخل كلمة المرور !";
//                       }
//                       return null;
//                     },
//                     isLastInput: true,
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//               BlocBuilder<HomeCubit, HomeStates>(
//                 builder: (context, state) {
//                   return CustomTextFormField(
//                     title: "كلمة المرور الجديدة",
//                     controller: widget.cubit.newPasswordController,
//                     filledColor: AppColors.white,
//                     titleColor: AppColors.grey8,
//                     titleFontSize: 15,
//                     maxLines: 1,
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         widget.cubit.changeNewVisibility();
//                       },
//                       icon: Icon(
//                         widget.cubit.isNewObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                     obscureText: widget.cubit.isNewObscure,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "من فضلك ادخل كلمة المرور !";
//                       }
//                       return null;
//                     },
//                     isLastInput: true,
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               BlocConsumer<HomeCubit, HomeStates>(
//                 listener: (context, state) {
//                   if (state is ChangePasswordSuccessState) {
//                     showToastificationWidget(
//                       message: "تم تغيير كلمه المرور بنجاح",
//                       context: context,
//                       notificationType: ToastificationType.success,
//                     );
//                     context.pushNamedAndRemoveUntil(
//                       Routes.home,
//                       predicate: (Route<dynamic> route) => false,
//                     );
//                   } else if (state is ChangePasswordFailState) {
//                     showToastificationWidget(
//                       message: state.message,
//                       context: context,
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is ChangePasswordLoadingState) {
//                     return const EmitLoadingItem();
//                   }
//                   return CustomButton(
//                     height: 50,
//                     borderRadius: 10,
//                     text: "تأكيد",
//                     onTap: () {
//                       widget.cubit.changePassword();
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
