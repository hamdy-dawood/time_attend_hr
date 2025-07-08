import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:time_attend_recognition/features/face_recognize/cubit/cubit.dart';
import 'package:time_attend_recognition/features/members/presentation/cubit/employees_cubit.dart';
import 'package:time_attend_recognition/features/members/presentation/cubit/employees_states.dart';
import 'package:toastification/toastification.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/header_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.getAllEmployees = true});

  final bool getAllEmployees;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        context.read<FaceRecognitionCubit>().isConnected
            ? getAllEmployees
                ? BlocProvider(
                    create: (context) => getIt<EmployeesCubit>()..getEmployees(),
                  )
                : BlocProvider(create: (context) => getIt<EmployeesCubit>())
            : BlocProvider(
                create: (context) => getIt<EmployeesCubit>()..getCachedEmployees(),
              ),
      ],
      child: HomeBody(getAllEmployees: getAllEmployees),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.getAllEmployees});

  final bool getAllEmployees;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    final homeCubit = context.read<HomeCubit>();
    final faceRecognitionCubit = context.read<FaceRecognitionCubit>();

    // faceRecognitionCubit.getConfig();

    faceRecognitionCubit.init();

    // if (faceRecognitionCubit.isConnected || kIsWeb) {
    //   homeCubit.getProfile();
    //   homeCubit.activation();
    // } else {
    //   faceRecognitionCubit.init();
    // }
    // _startTimer();
  }

  // void _startTimer() {
  //   // Create a timer that runs every 10
  //
  //   final homeCubit = context.read<HomeCubit>();
  //   final faceRecognitionCubit = context.read<FaceRecognitionCubit>();
  //
  //   Timer.periodic(const Duration(seconds: 10), (timer) {
  //     if (faceRecognitionCubit.isConnected) {
  //       if (homeCubit.isReUpload) return;
  //       if (faceRecognitionCubit.isDetectionView) return;
  //       homeCubit.loadCachedFacesWithoutStore().whenComplete(() {
  //         if (homeCubit.getUnUploadedCount() != 0) {
  //           homeCubit.reUploadAllCheckAttendances(
  //             wantPop: false,
  //             cachedFacesList: homeCubit.cachedFacesList,
  //             faceRecognitionCubit: faceRecognitionCubit,
  //           );
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");

    return BlocListener<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is ActivationFailState) {
          showToastificationWidget(
            message: state.message,
            context: context,
            duration: 10,
          );
        }
        if (state is ReUploadCheckAttendanceSuccessState) {
          context.read<HomeCubit>().iniCachedData();
          if (state.wantPop) {
            context.pop();
          }
          showToastificationWidget(
            message: "تم تسجيل البصمات بنجاح",
            context: context,
            notificationType: ToastificationType.success,
          );
        } else if (state is ReUploadCheckAttendanceFailState) {
          if (state.wantPop) {
            context.pop();
          }

          showToastificationWidget(
            message: state.message,
            context: context,
          );
        }
      },
      child: BlocBuilder<EmployeesCubit, EmployeesStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: BlocBuilder<HomeCubit, HomeStates>(
              builder: (context, state) {
                if (state is GetProfileLoadingState) {
                  return const EmitLoadingItem(
                    color: AppColors.primary,
                    size: 100,
                  );
                }
                return Stack(
                  children: [
                    Image.asset(
                      ImageManager.homeBg,
                      height: 1.sh,
                      width: 1.sw,
                      fit: BoxFit.cover,
                    ),
                    const HomeWidgets(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
