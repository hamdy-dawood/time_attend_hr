// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:time_attend_recognition/core/helper/extension.dart';
// import 'package:time_attend_recognition/core/utils/colors.dart';
// import 'package:time_attend_recognition/core/utils/image_manager.dart';
// import 'package:time_attend_recognition/features/cached_data/presentation/widgets/cached_data_table.dart';
// import 'package:time_attend_recognition/features/cached_data/presentation/widgets/upload_cached_finger_alert.dart';
// import 'package:time_attend_recognition/features/face_recognize/cubit/cubit.dart';
// import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
// import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';
//
// import '../widgets/delete_cached_finger_alert.dart';
// import '../widgets/screen_widgets.dart';
//
// class CachedDataScreen extends StatefulWidget {
//   const CachedDataScreen({super.key});
//
//   @override
//   State<CachedDataScreen> createState() => _CachedDataScreenState();
// }
//
// class _CachedDataScreenState extends State<CachedDataScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeCubit>().iniCachedData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const CachedDataBody();
//   }
// }
//
// class CachedDataBody extends StatelessWidget {
//   const CachedDataBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(right: 15, left: 15, top: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CachedDataRowHeaderWidget(),
//                 const SizedBox(height: 10),
//                 const CachedDataRowCountData(),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     const Flexible(child: CachedDataSearchTextField()),
//                     context.screenWidth > 800 ? SizedBox(width: 0.25.sw) : const SizedBox(width: 10),
//                     BlocBuilder<HomeCubit, HomeStates>(
//                       builder: (context, state) {
//                         return context.read<HomeCubit>().cachedFacesList.isNotEmpty
//                             ? ControlContainer(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       return const DeleteCachedFingerAlert();
//                                     },
//                                   );
//                                 },
//                                 color: AppColors.red3,
//                                 icon: ImageManager.deleteIcon,
//                                 title: "حذف السجل",
//                               )
//                             : const SizedBox();
//                       },
//                     ),
//                     const SizedBox(width: 5),
//                     BlocBuilder<FaceRecognitionCubit, FaceRecognitionStates>(
//                       builder: (context, state) {
//                         return BlocBuilder<HomeCubit, HomeStates>(
//                           builder: (context, state) {
//                             if (context.read<HomeCubit>().isReUpload == true) {
//                               return const SizedBox();
//                             }
//                             return context.read<FaceRecognitionCubit>().isConnected && context.read<HomeCubit>().getUnUploadedCount() != 0
//                                 ? ControlContainer(
//                                     onTap: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (_) {
//                                           return UploadCachedFingerAlert(
//                                             cubit: context.read<HomeCubit>(),
//                                             faceRecognitionCubit: context.read<FaceRecognitionCubit>(),
//                                           );
//                                         },
//                                       );
//                                     },
//                                     color: AppColors.blue3,
//                                     icon: ImageManager.uploadData,
//                                     title: "رفع البصمات",
//                                   )
//                                 : const SizedBox();
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Expanded(child: CachedDataTable()),
//           ],
//         ),
//       ),
//     );
//   }
// }
