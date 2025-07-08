// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
// import 'package:time_attend_recognition/core/helper/extension.dart';
// import 'package:time_attend_recognition/core/utils/colors.dart';
// import 'package:time_attend_recognition/core/utils/image_manager.dart';
// import 'package:time_attend_recognition/core/widget/custom_button.dart';
// import 'package:time_attend_recognition/core/widget/custom_cached_image.dart';
// import 'package:time_attend_recognition/core/widget/custom_text.dart';
// import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
// import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
// import 'package:time_attend_recognition/core/widget/pick_image_sheet.dart';
// import 'package:time_attend_recognition/core/widget/svg_icons.dart';
// import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
// import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';
// import 'package:toastification/toastification.dart';
//
// import '../cubit/home_cubit.dart';
//
// class ChangeCompanyDataAlert extends StatefulWidget {
//   const ChangeCompanyDataAlert({super.key, required this.cubit});
//
//   final HomeCubit cubit;
//
//   @override
//   State<ChangeCompanyDataAlert> createState() => _ChangeCompanyDataAlertState();
// }
//
// class _ChangeCompanyDataAlertState extends State<ChangeCompanyDataAlert> {
//   @override
//   void initState() {
//     widget.cubit.companyNameController.text = Caching.get(key: "companyName") ?? "";
//     widget.cubit.companyImageUploaded = Caching.get(key: "companyLogo") ?? "";
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: AppColors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
//       content: SizedBox(
//         width: context.screenWidth * 0.3,
//         child: Form(
//           key: widget.cubit.editProfileFormKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Flexible(
//                     child: CustomText(
//                       text: "تغيير اعدادات الشركة",
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
//               BlocConsumer<HomeCubit, HomeStates>(
//                 listener: (context, state) {
//                   if (state is PickedImageState) {
//                     Navigator.pop(context);
//                   }
//                 },
//                 builder: (context, state) {
//                   return Stack(
//                     children: [
//                       Stack(
//                         children: [
//                           PickImageWidget(
//                             title: "اختيار صورة",
//                             cubit: widget.cubit,
//                             onTapOne: () {
//                               widget.cubit.pickCompanyImageFile(
//                                 source: ImageSource.camera,
//                                 context: context,
//                               );
//                             },
//                             onTapTwo: () {
//                               widget.cubit.pickCompanyImageFile(
//                                 source: ImageSource.gallery,
//                                 context: context,
//                               );
//                             },
//                             child: widget.cubit.companyImage != null
//                                 ? ClipOval(
//                                     child: SizedBox.fromSize(
//                                       size: const Size.fromRadius(60),
//                                       child: kIsWeb
//                                           ? Image.network(
//                                               widget.cubit.companyImage!.path,
//                                               fit: BoxFit.cover,
//                                             )
//                                           : Image.file(
//                                               File(widget.cubit.companyImage!.path),
//                                               fit: BoxFit.cover,
//                                             ),
//                                     ),
//                                   )
//                                 : widget.cubit.companyImageUploaded.isNotEmpty
//                                     ? ClipOval(
//                                         child: SizedBox.fromSize(
//                                           size: const Size.fromRadius(60),
//                                           child: CustomCachedImage(
//                                             image: widget.cubit.companyImageUploaded,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       )
//                                     : CircleAvatar(
//                                         radius: 60,
//                                         backgroundColor: AppColors.secondary.withOpacity(0.3),
//                                         child: const Icon(
//                                           Icons.image,
//                                           size: 80,
//                                           color: AppColors.secondary,
//                                         ),
//                                       ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             left: 0,
//                             child: IconButton(
//                               onPressed: () {
//                                 widget.cubit.removeImageFile();
//                               },
//                               icon: const SvgIcon(
//                                 icon: ImageManager.deleteIcon,
//                                 color: AppColors.red,
//                                 height: 25,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               CustomTextFormField(
//                 title: "اسم الشركة",
//                 titleFontSize: 16,
//                 titleFontWeight: FontWeight.w500,
//                 titleColor: AppColors.grey,
//                 controller: widget.cubit.companyNameController,
//                 borderRadius: 6,
//                 hintText: "اسم الشركة...",
//                 filledColor: AppColors.white,
//               ),
//               const SizedBox(height: 20),
//               BlocConsumer<HomeCubit, HomeStates>(
//                 listener: (context, state) {
//                   if (state is EditProfileSuccessState) {
//                     Caching.put(key: "companyName", value: widget.cubit.companyNameController.text);
//                     Caching.put(
//                       key: "companyLogo",
//                       value: widget.cubit.companyImageUploaded,
//                     );
//                     context.pop();
//                     showToastificationWidget(
//                       message: "تم الحفظ بنجاح",
//                       context: context,
//                       notificationType: ToastificationType.success,
//                     );
//                   } else if (state is EditProfileFailState) {
//                     showToastificationWidget(
//                       message: state.message,
//                       context: context,
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   if (state is EditProfileLoadingState) {
//                     return const EmitLoadingItem(color: AppColors.primary);
//                   }
//                   return CustomButton(
//                     onTap: () {
//                       widget.cubit.editProfile();
//                     },
//                     height: 50,
//                     borderRadius: 10,
//                     color: AppColors.primary,
//                     fontColor: Colors.white,
//                     text: "حفظ",
//                     fontSize: 18,
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
