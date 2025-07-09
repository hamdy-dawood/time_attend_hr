import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/network/dio.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/internet_flash_bar.dart';
import 'package:time_attend_recognition/features/home/data/models/faces_detection_model.dart';

class FaceRecognitionCubit extends Cubit<FaceRecognitionStates> {
  FaceRecognitionCubit() : super(FaceRecognitionInitialState()) {
    monitorConnectivity();
  }

  static FaceRecognitionCubit get(context) => BlocProvider.of(context);

  //===================== CONFIG =================//

  final dioManager = DioManager();
  final logger = Logger();

  String androidKey = Caching.get(key: "android_key") ??
      "j63rQnZifPT82LEDGFa+wzorKx+M55JQlNr+S0bFfvMULrNYt+UEWIsa11V/Wk1bU9Srti0/FQqp"
          "UczeCxFtiEcABmZGuTzNd27XnwXHUSIMaFOkrpNyNE4MHb7HBm5kU/0J/SAMfybICCWyFajuZ4fL"
          "agozJV5DPKj22oFVaueWMjO/9fMvcps4u1AIiHH2rjP4mEYfiAE8nhHBa1Ou3u/WkXj6jdDafyJo"
          "AFtQHYJYKDU+hcbtCZ3P1f8y1JB5JxOf92ItK4euAt6/OFG9jGfKpo/Fs2mAgwxH3HoWMLJQ16Iy"
          "u2K6boMyDxRQtBJFTiktuJ+ltlay+dVqIi3Jpg==";

  String iosKey = Caching.get(key: "ios_key") ?? "";

  Future<void> getConfig() async {
    emit(GetConfigLoadingState());
    try {
      final response = await dioManager.get(
        ApiConstants.configUrl,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null) {
          androidKey = (data["androidKey"] as List<dynamic>).join(",");
          iosKey = (data["iosKey"] as List<dynamic>).join(",");

          Caching.put(key: "android_key", value: androidKey);
          Caching.put(key: "ios_key", value: iosKey);
        }

        emit(GetConfigSuccessState());
        init();
      } else {
        emit(GetConfigFailState(message: "${response.statusCode}"));
      }
    } on DioException catch (e) {
      handleGetStoresDioException(e);
    } catch (e) {
      emit(GetConfigFailState(message: 'An unknown error: $e'));
    }
  }

  void handleGetStoresDioException(DioException e) async {
    if (e.type == DioExceptionType.cancel) {
      emit(GetConfigFailState(message: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout) {
      emit(GetConfigNoInternetConnectionState());
    } else if (e.type == DioExceptionType.badResponse) {
      emit(GetConfigFailState(message: e.response?.data["message"]));
    } else {
      emit(GetConfigNoInternetConnectionState());
    }
    logger.e(e);
  }

  //===================== INIT FACE RECOGNIZE =================//

  String homeWarningState = "";
  bool homeVisibleWarning = false;

  Future<void> init() async {
    int facePluginState = -1;
    String warningState = "";
    bool visibleWarning = false;

    final facePlugin = FacesdkPlugin();
    debugPrint("androidKey: $androidKey");

    try {
      if (Platform.isAndroid) {
        await facePlugin.setActivation(androidKey).then((value) => facePluginState = value ?? -1);
      } else {
        await facePlugin.setActivation(iosKey).then((value) => facePluginState = value ?? -1);
      }

      if (facePluginState == 0) {
        await facePlugin.init().then((value) => facePluginState = value ?? -1);
      }
    } catch (e) {
      warningState = e.toString();
      visibleWarning = true;
    }

    int? liveLevel = Caching.get(key: "liveness_level");

    try {
      await facePlugin.setParam({'check_liveness_level': liveLevel ?? 0});
    } catch (e) {
      warningState = e.toString();
      visibleWarning = true;
    }

    if (facePluginState == -1) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facePluginState == -2) {
      warningState = "License expired!";
      visibleWarning = true;
    } else if (facePluginState == -3) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facePluginState == -4) {
      warningState = "No activated!";
      visibleWarning = true;
    } else if (facePluginState == -5) {
      warningState = "Init error!";
      visibleWarning = true;
    }

    debugPrint("warningState: $warningState");

    homeWarningState = warningState;
    homeVisibleWarning = visibleWarning;

    emit(ChangeInitState());
  }

  //============ ADD TO CACHE ==========//

  List<FacesDetectionModel> cachedFacesList = [];

  Future<void> addToCache({required FacesDetectionModel person}) async {
    cachedFacesList = await Caching.getCachedFaceDetection();
    cachedFacesList.add(person);
    Caching.cacheFaceDetection(faces: cachedFacesList);

    emit(ChangeCachedFacesState());
  }

  //============ EDIT IN CACHE ==========//

  Future<void> editInCache({
    required String id,
    required FacesDetectionModel person,
  }) async {
    cachedFacesList = await Caching.getCachedFaceDetection();
    cachedFacesList.removeWhere((FacesDetectionModel document) => document.id == id);
    cachedFacesList.add(person);
    Caching.cacheFaceDetection(faces: cachedFacesList);

    emit(ChangeCachedFacesState());
  }

  //============ REMOVE IN CACHE ==========//

  Future<void> removeFromCache({required String id}) async {
    cachedFacesList = await Caching.getCachedFaceDetection();
    cachedFacesList.removeWhere((FacesDetectionModel document) => document.id == id);
    Caching.cacheFaceDetection(faces: cachedFacesList);

    emit(ChangeCachedFacesState());
  }

  bool isDetectionView = false;

  //===================== INTERNET CONNECTIVITY CHECK =================//

  bool isConnected = kIsWeb ? true : false;
  bool isFirst = true;

  StreamSubscription? connectivitySubscription;

  void monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        isConnected = true;
        if (!isFirst) {
          showConnectionStatus(
            title: "عودة الاتصال بالانترنت !",
            message: "تم إعادة الاتصال بالانترنت بنجاح",
            icon: ImageManager.wifi,
            durationInSeconds: 5,
            iconColor: AppColors.green,
          );
        }
      } else {
        isConnected = false;
        showConnectionStatus(
          title: "فشل الاتصال بالانترنت !",
          message: "من فضلك حاول بالاتصال بالانترنت مرة اخرى",
          icon: ImageManager.wifiOff,
          durationInSeconds: 5,
          iconColor: AppColors.red,
        );
        isFirst = false;
      }
      emit(ChangeInitState());
    });
  }
}

//=====================================================================

abstract class FaceRecognitionStates {}

class FaceRecognitionInitialState extends FaceRecognitionStates {}

class ChangeInitState extends FaceRecognitionStates {}

class ChangeCachedFacesState extends FaceRecognitionStates {}

//============================== CONFIG =============================//

class GetConfigLoadingState extends FaceRecognitionStates {}

class GetConfigSuccessState extends FaceRecognitionStates {}

class GetConfigFailState extends FaceRecognitionStates {
  final String message;

  GetConfigFailState({required this.message});
}

class GetConfigNoInternetConnectionState extends FaceRecognitionStates {}
