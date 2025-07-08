// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:time_attend_recognition/core/helper/extension.dart';
// import 'package:time_attend_recognition/core/utils/colors.dart';
// import 'package:time_attend_recognition/core/widget/custom_alert.dart';
// import 'package:time_attend_recognition/core/widget/custom_text.dart';
// import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
// import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
// import 'package:toastification/toastification.dart';
//
// import '../cubit/employees_cubit.dart';
// import '../cubit/employees_states.dart';
//
// class DeleteEmployeesAlert extends StatelessWidget {
//   const DeleteEmployeesAlert({
//     super.key,
//     required this.cubit,
//     required this.id,
//     required this.name,
//   });
//
//   final String id, name;
//   final EmployeesCubit cubit;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: cubit,
//       child: CustomAlert(
//         title: "delete".tr(),
//         body: "confirm_delete".tr(args: [name]),
//         submitWidget: BlocConsumer<EmployeesCubit, EmployeesStates>(
//           listener: (context, state) {
//             if (state is DeleteEmployeesFailState) {
//               showToastificationWidget(
//                 message: state.message,
//                 context: context,
//               );
//             } else if (state is DeleteEmployeesSuccessState) {
//               context.pop();
//               showToastificationWidget(
//                 context: context,
//                 message: "deleted_successfully".tr(),
//                 notificationType: ToastificationType.success,
//               );
//               cubit.getEmployees();
//             }
//           },
//           builder: (context, state) {
//             if (state is DeleteEmployeesLoadingState) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: const EmitLoadingItemNoCenter(size: 20),
//               );
//             }
//             return TextButton(
//               onPressed: () {
//                 cubit.deleteMembers(id: id);
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: AppColors.primary,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: CustomText(
//                   text: "delete".tr(),
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
