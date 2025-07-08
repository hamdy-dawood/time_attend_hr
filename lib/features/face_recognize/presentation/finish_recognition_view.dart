import 'dart:async';

import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:time_attend_recognition/features/face_recognize/face_detection_class.dart';
import 'package:time_attend_recognition/features/face_recognize/widgets/custom_paint_face.dart';
import 'package:time_attend_recognition/features/home/presentation/screens/home_screen.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class FinishFaceRecognitionView extends StatefulWidget {
  const FinishFaceRecognitionView({super.key});

  @override
  State<StatefulWidget> createState() => FinishFaceRecognitionViewState();
}

class FinishFaceRecognitionViewState extends State<FinishFaceRecognitionView> {
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
    return PopScope(
      onPopInvoked: (_){
        MdSoftFaceDetection.faceDetectionController?.startCamera(getCameraLens());
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
              MdSoftFaceDetection.faceDetectionController?.startCamera(getCameraLens());
            },
            icon: SvgPicture.asset(
              ImageManager.cancelBack,
              height: 28,
            ),
          ),
          title: const CustomText(
            text: "انهاء الحضور",
            color: AppColors.red,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            const FaceDetectionView(),
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
      ),
    );
  }
}

class FaceDetectionView extends StatefulWidget implements FaceDetectionInterface {
  const FaceDetectionView({
    super.key,
  });

  @override
  Future<void> onFaceDetected(dynamic faces) async {
    final Map<String, dynamic> detected = await MdSoftFaceDetection.onFaceDetectedOneUser(faces: faces);

    if (detected["status"] == true) {
      MagicRouter.navigateTo(
        page: const HomeScreen(getAllEmployees: false),
        withHistory: false,
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _FaceDetectionViewState();
}

class _FaceDetectionViewState extends State<FaceDetectionView> {
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

    MdSoftFaceDetection.userFaceDetectionController = FaceDetectionViewController(id, widget);

    await MdSoftFaceDetection.userFaceDetectionController?.initHandler();

    await MdSoftFaceDetection.userFaceSdkPlugin.setParam({'check_liveness_level': livenessLevel});

    await MdSoftFaceDetection.userFaceDetectionController?.startCamera(cameraLens);
  }
}
