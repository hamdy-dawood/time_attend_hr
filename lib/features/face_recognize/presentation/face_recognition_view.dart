import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/features/face_recognize/cubit/cubit.dart';
import 'package:time_attend_recognition/features/face_recognize/face_detection_class.dart';
import 'package:time_attend_recognition/features/face_recognize/widgets/attend_result_dialog.dart';
import 'package:time_attend_recognition/features/face_recognize/widgets/custom_paint_face.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_states.dart';

import '../../members/data/models/employees_model.dart';
import 'finish_recognition_view.dart';

// ignore: must_be_immutable
class FaceRecognitionView extends StatefulWidget {
  const FaceRecognitionView({super.key, required this.homeCubit, required this.event, required this.subjectName});

  final HomeCubit homeCubit;
  final String subjectName;
  final int event;

  @override
  State<StatefulWidget> createState() => FaceRecognitionViewState();
}

class FaceRecognitionViewState extends State<FaceRecognitionView> {
  Timer? _timer;
  Timer? _waitingTimer;

  @override
  void initState() {
    super.initState();
    MdSoftFaceDetection.classFaces = null;
    context.read<FaceRecognitionCubit>().isDetectionView = true;
    changeState();
  }

  int waitingDetect = Caching.get(key: "waitingDetect") ?? 120;

  void changeState() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      setState(() {});
    });

    _waitingTimer = Timer.periodic(Duration(seconds: waitingDetect), (Timer timer) {
      context.pop();
    });
  }

  void resetDetectionTimer() {
    _waitingTimer?.cancel();
    _waitingTimer = Timer.periodic(Duration(seconds: waitingDetect), (Timer timer) {
      context.pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waitingTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<FaceRecognitionCubit, FaceRecognitionStates>(
        builder: (context, state) {
          return BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {
              if (state is MakeFingerprintSuccessState) {
                resetDetectionTimer();
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await AudioPlayer().play(AssetSource("audios/thanks.mp3"));
                });

                MdSoftFaceDetection.faceDetectionController?.stopCamera();
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  barrierDismissible: false,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 2), () {
                      context.pop();
                      MdSoftFaceDetection.faceDetectionController?.startCamera(getCameraLens());
                    });
                    return AttendResultDialog(
                      name: state.name,
                      homeCubit: widget.homeCubit,
                    );
                  },
                );
              }
            },
            builder: (c, state) {
              return Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  leading: const SizedBox(),
                  title: CustomText(
                    text: " حضورة مادة ${widget.subjectName}",
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  centerTitle: true,
                  // bottom: PreferredSize(
                  //   preferredSize: const Size.fromHeight(5),
                  //   child: Container(
                  //     color: faceRecognitionCubit.isConnected ? AppColors.transparent : Colors.red,
                  //     height: 5,
                  //   ),
                  // ),
                ),
                body: Stack(
                  children: [
                    FaceDetection(
                      homeCubit: widget.homeCubit,
                      subjectName: widget.subjectName,
                      event: widget.event,
                    ),
                    SizedBox(
                      width: 1.sw,
                      height: 1.sh,
                      child: CustomPaint(
                        painter: FacePainter(
                          faces: MdSoftFaceDetection.classFaces,
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: AppColors.white,
                  onPressed: () {
                    MagicRouter.navigateTo(
                      page: const FinishFaceRecognitionView(),
                    );
                  },
                  label: const CustomText(
                    text: "انهاء الحضور",
                    color: AppColors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FaceDetection extends StatefulWidget implements FaceDetectionInterface {
  const FaceDetection({
    super.key,
    required this.homeCubit,
    required this.subjectName,
    required this.event,
  });

  final HomeCubit homeCubit;
  final String subjectName;
  final int event;

  @override
  Future<void> onFaceDetected(dynamic faces) async {
    final Map<String, dynamic> detected = await MdSoftFaceDetection.onFaceDetected(faces: faces);

    if (detected["status"] == true) {
      EmployeesModel employee = detected["person"];

      final DateTime now = DateTime.now();

      if (homeCubit.lastAttendanceTimes.containsKey(employee.id)) {
        final DateTime lastAttendanceTime = homeCubit.lastAttendanceTimes[employee.id]!;
        final Duration timeDifference = now.difference(lastAttendanceTime);

        if (timeDifference.inSeconds < homeCubit.configReAttend) {
          return;
        }
      }

      // Update the last attendance time.
      homeCubit.lastAttendanceTimes[employee.id] = now;

      // Save the updated map to SharedPreferences.
      await homeCubit.saveLastAttendanceTimes();

      homeCubit.fingerprint(
        enrollId: employee.enrollId,
        name: employee.displayName,
        event: event,
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'facedetectionview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return UiKitView(
        viewType: 'facedetectionview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
  }

  void _onPlatformViewCreated(int id) async {
    int cameraLens = getCameraLens();
    int livenessLevel = getLivenessLevel();

    MdSoftFaceDetection.faceDetectionController = FaceDetectionViewController(id, widget);

    await MdSoftFaceDetection.faceDetectionController?.initHandler();

    await MdSoftFaceDetection.faceSdkPlugin.setParam({'check_liveness_level': livenessLevel});

    await MdSoftFaceDetection.faceDetectionController?.startCamera(cameraLens);
  }
}
