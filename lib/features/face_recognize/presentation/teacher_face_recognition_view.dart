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
  const TeacherFaceRecognitionView({super.key, required this.homeCubit, this.manual = false});

  final HomeCubit homeCubit;
  final bool manual;

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
            toolbarHeight: 80,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: SvgPicture.asset(
                ImageManager.cancelBack,
                height: 28,
              ),
            ),
            title: const CustomText(
              text: "تحقق من هوية المدرس",
              color: AppColors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: CustomText(
                    text: "يرجي النظر إلى الكاميرا للتحقق من هويتك قبل بدء تسجيل الحضور",
                    color: AppColors.black2,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    maxLines: 10,
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              TeacherFaceDetection(
                homeCubit: widget.homeCubit,
                faceRecognitionCubit: faceRecognitionCubit,
                manual: widget.manual,
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
    required this.manual,
  });

  final HomeCubit homeCubit;
  final FaceRecognitionCubit faceRecognitionCubit;
  final bool manual;

  @override
  Future<void> onFaceDetected(dynamic faces) async {
    final Map<String, dynamic> detected = await MdSoftFaceDetection.onFaceDetected(faces: faces);

    if (detected["status"] == true) {
      EmployeesModel teacher = detected["person"];

      Logger().i("Teacher Data : ${teacher.enrollId} ${teacher.displayName}");

      MdSoftFaceDetection.specificTeacher = teacher;

      MagicRouter.navigateReplacement(
        page: ChooseProjectScreen(teacher: teacher, manual: manual),
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
