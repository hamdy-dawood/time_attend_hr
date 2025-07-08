import 'dart:async';

import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/features/face_recognize/cubit/cubit.dart';
import 'package:time_attend_recognition/features/face_recognize/face_detection_class.dart';
import 'package:time_attend_recognition/features/face_recognize/widgets/custom_paint_face.dart';
import 'package:time_attend_recognition/features/home/presentation/cubit/home_cubit.dart';
import 'package:time_attend_recognition/features/members/data/models/employees_model.dart';

import 'choose_subject.dart';

// ignore: must_be_immutable
class TeacherFaceRecognitionView extends StatefulWidget {
  const TeacherFaceRecognitionView({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  State<StatefulWidget> createState() => TeacherFaceRecognitionViewState();
}

class TeacherFaceRecognitionViewState extends State<TeacherFaceRecognitionView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    changeState();
  }

  void changeState() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaceRecognitionCubit, FaceRecognitionStates>(
      builder: (context, state) {
        final faceRecognitionCubit = context.read<FaceRecognitionCubit>();
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: SvgPicture.asset(
                ImageManager.cancelBack,
                height: 28,
              ),
            ),
            title: CustomText(
              text: faceRecognitionCubit.isConnected ? "بدئ التعرف" : "تحقق من اتصالك بالانترنت",
              color: faceRecognitionCubit.isConnected ? AppColors.primary : AppColors.red,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(5),
              child: Container(
                color: faceRecognitionCubit.isConnected ? AppColors.transparent : Colors.red,
                height: 5,
              ),
            ),
          ),
          body: Stack(
            children: [
              TeacherFaceDetection(
                homeCubit: widget.homeCubit,
                faceRecognitionCubit: faceRecognitionCubit,
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
        );
      },
    );
  }
}

class TeacherFaceDetection extends StatefulWidget implements FaceDetectionInterface {
  const TeacherFaceDetection({
    super.key,
    required this.homeCubit,
    required this.faceRecognitionCubit,
  });

  final HomeCubit homeCubit;
  final FaceRecognitionCubit faceRecognitionCubit;

  @override
  Future<void> onFaceDetected(dynamic faces) async {
    final Map<String, dynamic> detected = await MdSoftFaceDetection.onFaceDetected(faces: faces);

    if (detected["status"] == true) {
      EmployeesModel person = detected["person"];

      Logger().i("person data : ${person.enrollId} ${person.displayName}");

      MdSoftFaceDetection.specificTeacher = person;

      MagicRouter.navigateReplacement(
        page: ChooseProjectScreen(
          enrollId: person.enrollId,
        ),
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _TeacherFaceDetectionState();
}

class _TeacherFaceDetectionState extends State<TeacherFaceDetection> {
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
