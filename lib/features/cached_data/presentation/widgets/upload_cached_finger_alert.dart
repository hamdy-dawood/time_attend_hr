// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:time_attend_recognition/core/helper/extension.dart';
// import 'package:time_attend_recognition/core/utils/colors.dart';
// import 'package:time_attend_recognition/core/widget/custom_alert.dart';
// import 'package:time_attend_recognition/core/widget/custom_text.dart';
// import 'package:time_attend_recognition/features/face_recognize/cubit/cubit.dart';
// import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
// import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';
// import 'package:time_attend_recognition/features/home/presentation/widgets/upload_cached_faces_loading_dialog.dart';
//
// class UploadCachedFingerAlert extends StatelessWidget {
//   const UploadCachedFingerAlert({super.key, required this.cubit, required this.faceRecognitionCubit});
//
//   final HomeCubit cubit;
//   final FaceRecognitionCubit faceRecognitionCubit;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomAlert(
//       title: "تسجيل البصمات",
//       body: "هل انت متأكد من تسجيل جميع البصمات ؟",
//       submitWidget: BlocBuilder<HomeCubit, HomeStates>(
//         builder: (context, state) {
//           return TextButton(
//             onPressed: () async {
//               context.pop();
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (context) => const UploadCachedFacesLoadingDialog(),
//               );
//
//               await cubit.reUploadAllCheckAttendances(
//                 wantPop: true,
//                 cachedFacesList: cubit.cachedFacesList,
//                 faceRecognitionCubit: faceRecognitionCubit,
//               );
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: AppColors.primary,
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w),
//               child: const CustomText(
//                 text: "تسجيل",
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
