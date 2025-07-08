import 'dart:async';

import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/features/members/domain/entities/employees_entity.dart';

import '../members/data/models/employees_model.dart';

//========================  FACE DETECTION CLASS ==========================//

class MdSoftFaceDetection {
  static List<EmployeesEntity> personList = [];

  static dynamic classFaces;
  static dynamic identifiedFace;

  static final faceSdkPlugin = FacesdkPlugin();
  static FaceDetectionViewController? faceDetectionController;

  //============ DETECT FACE =============//

  static Future<Map<String, dynamic>> onFaceDetected({
    required dynamic faces,
  }) async {
    final double livenessThreshold = getLivenessThreshold();
    final double identifyThreshold = getIdentifyThreshold();

    classFaces = faces;

    double maxSimilarity = -1;
    double maxLiveness = -1;
    EmployeesEntity? enrolledPerson;

    if (faces.length > 0) {
      dynamic face = faces[0];

      for (var person in personList) {
        double similarity = person.faceId != null ? await faceSdkPlugin.similarityCalculation(face['templates'], person.faceId!) ?? -1 : -1;
        if (similarity > maxSimilarity) {
          maxSimilarity = similarity;
          maxLiveness = face['liveness'];
          identifiedFace = face['faceJpg'];
          enrolledPerson = person;
        }
      }

      if (maxSimilarity > identifyThreshold && maxLiveness > livenessThreshold) {
        return {
          "status": true,
          "person": enrolledPerson,
        };
      }
    }
    return {
      "status": false,
    };
  }

  //======================== ENROLL FACE =====================//

  static Future<Map<String, dynamic>> enrollPerson({
    required XFile image,
    required String editPersonId,
  }) async {
    bool recognized = false;
    String personId = "";
    double maxSimilarity = -1;

    final double identifyThreshold = getIdentifyThreshold();

    try {
      var rotatedImage = await FlutterExifRotation.rotateImage(path: image.path);

      final List<dynamic> faces = await faceSdkPlugin.extractFaces(rotatedImage.path);

      if (faces.isEmpty) {
        return {
          "status": false,
          "message": "لم يتم الكشف عن الوجه!",
        };
      } else if (faces.length > 1) {
        return {
          "status": false,
          "message": "تم اكتشاف اكثر من وجه!",
        };
      } else {
        dynamic face = faces[0];

        for (var person in personList) {
          double similarity = person.faceId != null ? await faceSdkPlugin.similarityCalculation(face['templates'], person.faceId!) ?? -1 : -1;

          if (similarity > maxSimilarity) {
            maxSimilarity = similarity;
            personId = person.id;
          }
        }

        if (maxSimilarity > identifyThreshold) {
          recognized = true;
        }

        if (editPersonId.isNotEmpty) {
          /// edit
          if (personId != editPersonId) {
            return {
              "status": false,
              "message": "يوجد تطابق مع شخص اخر!",
            };
          } else {
            return {
              "status": true,
              "template": faces.first['templates'],
              "message": "تم اكتشاف الوجه",
            };
          }
        } else {
          /// add
          if (recognized) {
            return {
              "status": false,
              "message": "هذا الشخص موجود بالفعل!",
            };
          } else {
            return {
              "status": true,
              "template": faces.first['templates'],
              "message": "تم اكتشاف الوجه",
            };
          }
        }
      }
    } catch (e) {
      return {
        "status": false,
        "message": "An error occurred during enrollment: $e",
      };
    }
  }

  //======================== DETECT FACE ONE USER =====================//

  static bool recognized = false;
  static EmployeesModel? specificTeacher;
  static final userFaceSdkPlugin = FacesdkPlugin();
  static FaceDetectionViewController? userFaceDetectionController;

  static Future<Map<String, dynamic>> onFaceDetectedOneUser({
    required dynamic faces,
  }) async {
    final double livenessThreshold = getLivenessThreshold();
    final double identifyThreshold = getIdentifyThreshold();

    if (recognized == true) {
      return {
        "status": false,
      };
    }

    identifiedFace = faces;

    if (faces.length > 0) {
      dynamic face = faces[0];

      double similarity = await userFaceSdkPlugin.similarityCalculation(
          face['templates'], specificTeacher!.faceId!) ??
          -1;

      double liveness = face['liveness'];

      if (similarity > identifyThreshold && liveness > livenessThreshold) {
        recognized = true;

        userFaceDetectionController?.stopCamera();
        identifiedFace = null;
        recognized = false;

        return {
          "status": true,
          "message": "Successfully detected the specific user.",
          "person": specificTeacher,
        };
      }
    }

    return {
      "status": false,
      "message": "Failed to detect the specific user.",
    };
  }
}



// ======================= GETTERS =======================//

double getLivenessThreshold() {
  String? value = Caching.get(key: AppConstance.livenessThresholdKey);
  return double.tryParse(value ?? "0.7") ?? 0.7;
}

double getIdentifyThreshold() {
  String? value = Caching.get(key: AppConstance.identifyThresholdKey);
  return double.tryParse(value ?? "0.8") ?? 0.8;
}

int getCameraLens() {
  dynamic value = Caching.get(key: AppConstance.cameraLensKey);
  return value ?? 1;
}

int getLivenessLevel() {
  dynamic value = Caching.get(key: AppConstance.livenessLevelKey);
  return value ?? 0;
}
