import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/helper/uploads_images.dart';
import 'package:time_attend_recognition/core/network/dio.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/constance.dart';
import 'package:time_attend_recognition/features/home/data/models/faces_detection_model.dart';
import 'package:time_attend_recognition/features/members/domain/entities/employees_entity.dart';

import '../../domain/entities/members_attendance_entity.dart';
import '../../domain/repositories/base_home_repository.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final BaseHomeRepository baseHomeRepository;

  HomeCubit(this.baseHomeRepository) : super(HomeInitialState());

  //========================= GET PROFILE ===========================//

  // Future<void> getProfile() async {
  //   emit(GetProfileLoadingState());
  //
  //   final response = await baseHomeRepository.getProfile();
  //   response.fold(
  //     (l) => emit(GetProfileFailState(message: l.message)),
  //     (r) async {
  //       await Caching.setProfile(
  //         ProfileModel(
  //           id: r.id,
  //           displayName: r.displayName,
  //           username: r.username,
  //           roles: r.roles,
  //           active: r.active,
  //           timezone: r.timezone,
  //           image: r.image,
  //           permissions: r.permissions,
  //           deleted: r.deleted,
  //           expiredAt: r.expiredAt,
  //           createdAt: r.createdAt,
  //           updatedAt: r.updatedAt,
  //           v: r.v,
  //         ),
  //       );
  //
  //       Caching.put(key: "companyName", value: r.displayName);
  //       Caching.put(key: "companyLogo", value: r.image);
  //       emit(GetProfileSuccessState());
  //     },
  //   );
  // }

  //========================= ACTIVATION ===========================//

  // Future<void> activation() async {
  //   final response = await baseHomeRepository.activation();
  //   response.fold(
  //     (l) => emit(ActivationFailState(message: l.message)),
  //     (r) {
  //       if (r == false) {
  //         emit(ActivationFailState(message: "تم حظرك من قبل الادارة"));
  //       } else {
  //         emit(ActivationSuccessState());
  //
  //         getHome();
  //         getReport();
  //       }
  //     },
  //   );
  // }

  //========================= CHANGE PASSWORD ===========================//

  // final formKey = GlobalKey<FormState>();
  // TextEditingController oldPasswordController = TextEditingController();
  // TextEditingController newPasswordController = TextEditingController();
  //
  // Future<void> changePassword() async {
  //   if (formKey.currentState!.validate()) {
  //     emit(ChangePasswordLoadingState());
  //     final response = await baseHomeRepository.changePassword(
  //       oldPassword: oldPasswordController.text,
  //       newPassword: newPasswordController.text,
  //     );
  //     response.fold(
  //       (l) => emit(ChangePasswordFailState(message: l.message)),
  //       (r) => emit(ChangePasswordSuccessState()),
  //     );
  //   }
  // }

  //========================= EDIT PROFILE ===========================//

  // final editProfileFormKey = GlobalKey<FormState>();
  // final TextEditingController companyNameController = TextEditingController();
  //
  // Future<void> editProfile() async {
  //   if (editProfileFormKey.currentState!.validate()) {
  //     emit(EditProfileLoadingState());
  //
  //     try {
  //       if (companyImage != null) {
  //         if (kIsWeb) {
  //           companyImageUploaded = await ImagesService.uploadImageWeb(companyImage!);
  //         } else {
  //           companyImageUploaded = await ImagesService.uploadImage(companyImage!.path);
  //         }
  //       }
  //     } on Exception catch (e) {
  //       emit(EditProfileFailState(message: e.toString()));
  //       return;
  //     }
  //
  //     final response = await baseHomeRepository.editProfile(
  //       displayName: companyNameController.text,
  //       image: companyImageUploaded,
  //     );
  //     response.fold(
  //       (l) => emit(EditProfileFailState(message: l.message)),
  //       (r) => emit(EditProfileSuccessState()),
  //     );
  //   }
  // }

  //================================

  // bool isOldObscure = true;
  // bool isNewObscure = true;
  //
  // void changeOldVisibility() {
  //   isOldObscure = !isOldObscure;
  //   emit(ChangeOldVisibilityState());
  // }
  //
  // void changeNewVisibility() {
  //   isNewObscure = !isNewObscure;
  //   emit(ChangeNewVisibilityState());
  // }

  //========================= GET HOME COUNT ===========================//

  // num employeesCount = 0;
  // num usersCount = 0;
  // num attendancesCount = 0;
  // num actionsCount = 0;
  // num projectsCount = 0;
  // num jobsCount = 0;
  // num holidaysCount = 0;
  //
  // Future<void> getHome() async {
  //   emit(GetHomeCountLoadingState());
  //
  //   final response = await baseHomeRepository.getHome();
  //   response.fold(
  //     (l) => emit(GetHomeCountFailState(message: l.message)),
  //     (r) {
  //       employeesCount = r.employeesCount;
  //       usersCount = r.usersCount;
  //       attendancesCount = r.attendancesCount;
  //       actionsCount = r.actionsCount;
  //       projectsCount = r.projectsCount;
  //       jobsCount = r.jobsCount;
  //       holidaysCount = r.holidaysCount;
  //       emit(GetHomeCountSuccessState());
  //     },
  //   );
  // }

  //========================= GET HOME REPORT COUNT ===========================//

  // int presentCount = 0;
  // int absentCount = 0;
  // int totalReportCount = 0;
  //
  // Future<void> getReport() async {
  //   emit(GetHomeCountLoadingState());
  //
  //   final response = await baseHomeRepository.getReport();
  //   response.fold(
  //     (l) => emit(GetHomeCountFailState(message: l.message)),
  //     (r) {
  //       presentCount = r.presentCount;
  //       absentCount = r.absentCount;
  //       totalReportCount = r.totalCount;
  //       emit(GetHomeCountSuccessState());
  //     },
  //   );
  // }

  //========================= CHECK ATTENDANCE ===========================//

  // final dioManager = DioManager();
  // final logger = Logger();
  // final Uuid uuid = const Uuid();
  //
  // Future<void> checkAttendance({
  //   EmployeesModel? memberEmployee,
  //   required String projectId,
  //   required String projectName,
  //   required bool isOpen,
  //   required FaceRecognitionCubit faceRecognitionCubit,
  // }) async {
  //   if (isOpen) {
  //     faceRecognitionCubit.addToCache(
  //       person: FacesDetectionModel(
  //         id: uuid.v4().toString(),
  //         uploadedToServer: false,
  //         memberId: memberEmployee!.id,
  //         memberName: memberEmployee.displayName,
  //         projectId: projectId,
  //         projectName: projectName,
  //         openTime: "0",
  //         closeTime: "0",
  //         createdAt: "${DateTime.now()}",
  //         serverReplay: "",
  //       ),
  //     );
  //     emit(CachedDataSuccessState(employee: memberEmployee));
  //   } else {
  //     emit(ClosedTimeState());
  //   }
  // }
  //
  // //========================= RE CHECK ATTENDANCE ===========================//
  //
  // bool isReUpload = false;
  // int uploadedCount = 0;
  // int totalCount = 0;
  //
  // Future<void> reUploadAllCheckAttendances({
  //   required List<FacesDetectionModel> cachedFacesList,
  //   required FaceRecognitionCubit faceRecognitionCubit,
  //   required bool wantPop,
  // }) async {
  //   isReUpload = true;
  //   uploadedCount = 0;
  //   totalCount = cachedFacesList.where((face) => !face.uploadedToServer).length;
  //
  //   emit(ReUploadCheckAttendanceLoadingState());
  //
  //   try {
  //     final facesToReUpload = cachedFacesList.where((face) => !face.uploadedToServer).toList();
  //
  //     for (var face in facesToReUpload) {
  //       final result = await reUploadCheckAttendance(
  //         wantPop: wantPop,
  //         memberEmployee: face,
  //         memberId: face.memberId,
  //         projectId: face.projectId,
  //         projectName: face.projectName,
  //         isOpen: isOpen(face.openTime, face.closeTime),
  //         faceRecognitionCubit: faceRecognitionCubit,
  //       );
  //
  //       if (!result) {
  //         emit(ReUploadCheckAttendanceFailState(message: "فشل تسجيل احد البصمات !", wantPop: wantPop));
  //       }
  //
  //       // Wait for 1 seconds before the next iteration
  //       await Future.delayed(const Duration(seconds: 1));
  //     }
  //
  //     isReUpload = false;
  //     emit(ReUploadCheckAttendanceSuccessState(wantPop: wantPop));
  //   } catch (e) {
  //     isReUpload = false;
  //     emit(ReUploadCheckAttendanceFailState(message: 'An Unknown Error: $e', wantPop: wantPop));
  //   }
  // }
  //
  // Future<bool> reUploadCheckAttendance({
  //   FacesDetectionModel? memberEmployee,
  //   required String memberId,
  //   required String projectId,
  //   required String projectName,
  //   required bool isOpen,
  //   required FaceRecognitionCubit faceRecognitionCubit,
  //   required bool wantPop,
  // }) async {
  //   if (!isOpen) {
  //     emit(ClosedTimeState());
  //     return false;
  //   }
  //
  //   try {
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     final response = await dioManager.post(
  //       ApiConstants.attendanceCheck,
  //       data: {
  //         "time": memberEmployee!.createdAt,
  //         "member": memberId,
  //         "project": projectId,
  //         "projectName": projectName,
  //       },
  //     );
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       faceRecognitionCubit.editInCache(
  //         id: memberEmployee.id,
  //         person: FacesDetectionModel(
  //           id: memberEmployee.id,
  //           uploadedToServer: true,
  //           memberId: memberEmployee.id,
  //           memberName: memberEmployee.memberName,
  //           projectId: projectId,
  //           projectName: projectName,
  //           openTime: memberEmployee.openTime,
  //           closeTime: memberEmployee.closeTime,
  //           createdAt: memberEmployee.createdAt,
  //           serverReplay: response.data["success"] == false ? "${response.data["message"]}" : "",
  //         ),
  //       );
  //
  //       uploadedCount++;
  //       emit(ReUploadCheckAttendanceLoadingState());
  //
  //       return true;
  //     } else {
  //       emit(ReUploadCheckAttendanceFailState(message: response.data["message"], wantPop: wantPop));
  //       return false;
  //     }
  //   } on DioException catch (e) {
  //     handleReCheckAttendanceDioException(e, wantPop);
  //     return false;
  //   } catch (e) {
  //     emit(ReUploadCheckAttendanceFailState(message: 'An unknown error: $e', wantPop: wantPop));
  //     return false;
  //   }
  // }
  //
  // void handleReCheckAttendanceDioException(DioException e, bool wantPop) async {
  //   if (e.type == DioExceptionType.cancel) {
  //     emit(ReUploadCheckAttendanceFailState(message: "Request was cancelled", wantPop: wantPop));
  //   } else if (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout) {
  //     emit(ReCheckAttendanceNoInternetConnectionState());
  //   } else if (e.type == DioExceptionType.badResponse) {
  //     emit(ReUploadCheckAttendanceFailState(message: e.response?.data["message"], wantPop: wantPop));
  //   } else {
  //     emit(ReCheckAttendanceNoInternetConnectionState());
  //   }
  //   logger.e(e);
  // }

  //========================= IS OPEN ===========================//

  // bool isOpen(String openTime, String closeTime) {
  //   final now = TimeOfDay.now();
  //   final opening = _parseTimeOfDay(openTime);
  //   final closing = _parseTimeOfDay(closeTime);
  //
  //   // Convert times to minutes since midnight.
  //   final nowMinutes = now.hour * 60 + now.minute;
  //   final openMinutes = opening.hour * 60 + opening.minute;
  //   final closeMinutes = closing.hour * 60 + closing.minute;
  //
  //   // If the shop does not cross midnight:
  //   if (openMinutes < closeMinutes) {
  //     return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
  //   } else {
  //     // Overnight schedule:
  //     // The shop is open if it is after opening (today) OR before closing (after midnight).
  //     return nowMinutes >= openMinutes || nowMinutes <= closeMinutes;
  //   }
  // }
  //
  // TimeOfDay _parseTimeOfDay(String timeString) {
  //   final parts = timeString.split(':');
  //   final hour = int.parse(parts[0]);
  //   final minute = int.parse(parts[1]);
  //   return TimeOfDay(hour: hour, minute: minute);
  // }

  // //====================== CACHING LAST ATTENDANCE TIMES ===========================//

  Map<String, DateTime> lastAttendanceTimes = {};

  Future<void> saveLastAttendanceTimes() async {
    // Convert the map to a JSON string before saving.
    Map<String, String> stringifiesMap = lastAttendanceTimes.map(
      (key, value) => MapEntry(key, value.toIso8601String()),
    );
    await Caching.put(key: "lastAttendanceTimes", value: jsonEncode(stringifiesMap));
  }

  Future<void> loadLastAttendanceTimes() async {
    // Retrieve the JSON string and decode it back to a map.
    String? jsonString = Caching.get(key: "lastAttendanceTimes");
    if (jsonString != null) {
      Map<String, dynamic> decodedMap = jsonDecode(jsonString);
      lastAttendanceTimes = decodedMap.map(
        (key, value) => MapEntry(
          key,
          DateTime.parse(value),
        ),
      );
    }
  }

  int configReAttend = Caching.get(key: "configReAttend") ?? 30;

  ///========================= FINGERPRINT ===========================//

  final dioManager = DioManager();
  final logger = Logger();

  Future<void> fingerprint({
    required String enrollId,
    required String name,
    required int event,
  }) async {
    emit(MakeFingerprintLoadingState());

    try {
      final response = await dioManager.post(
        ApiConstants.fingerprint,
        data: {
          "enrollid": enrollId,
          "name": name,
          "event": event,
          "time": "${DateTime.now()}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(MakeFingerprintSuccessState(name: name));
      } else {
        emit(MakeFingerprintFailState(message: response.data["error"]));
      }
    } on DioException catch (e) {
      handleFingerprintDioException(e);
    } catch (e) {
      emit(MakeFingerprintFailState(message: 'An unknown error: $e'));
    }
  }

  Future<void> fingerprintSelectedStudents({
    required List<EmployeesEntity> employees,
    required int event,
  }) async {
    emit(MakeFingerprintLoadingState());

    try {
      for (var employee in employees) {
        final response = await dioManager.post(
          ApiConstants.fingerprint,
          data: {
            "enrollid": employee.enrollId,
            "name": employee.displayName,
            "event": event,
            "time": "${DateTime.now()}",
          },
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          emit(MakeFingerprintFailState(message: response.data["error"]));
          return;
        }
      }

      emit(MakeFingerprintSuccessState(name: "تم إرسال البصمات بنجاح"));
    } on DioException catch (e) {
      handleFingerprintDioException(e);
    } catch (e) {
      emit(MakeFingerprintFailState(message: 'An unknown error: $e'));
    }
  }

  void handleFingerprintDioException(DioException e) async {
    if (e.type == DioExceptionType.cancel) {
      emit(MakeFingerprintFailState(message: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout) {
      emit(ReCheckAttendanceNoInternetConnectionState());
    } else if (e.type == DioExceptionType.badResponse) {
      emit(MakeFingerprintFailState(message: e.response?.data["error"]));
    } else {
      emit(ReCheckAttendanceNoInternetConnectionState());
    }
    logger.e(e);
  }

//========================= GET MEMBERS ATTENDANCE COUNT ===========================//

  int count = 0;

  Future<void> membersAttendanceCount({bool resetPage = false, required int status}) async {
    emit(GetMembersAttendanceLoadingState());

    final response = await baseHomeRepository.membersAttendanceCount(
      startDate: firstDateFormat,
      endDate: lastDateFormat,
      salaryType: salaryId,
    );
    response.fold(
      (l) => emit(GetMembersAttendanceFailState(message: l.message)),
      (r) {
        count = status == 0 ? r.absentCount : r.presentCount;
        emit(GetMembersAttendanceCountSuccessState());
        if (resetPage) page = 1;
        membersAttendance(status: status);
      },
    );
  }

//========================= GET MEMBERS ATTENDANCE ===========================//

  List<MembersAttendanceEntity> membersAttendanceList = [];

  int page = 1;

  Future<void> membersAttendance({required int status}) async {
    emit(GetMembersAttendanceLoadingState());
    final response = await baseHomeRepository.membersAttendance(
      status: status,
      skip: page - 1,
      startDate: firstDateFormat,
      endDate: lastDateFormat,
      salaryType: salaryId,
    );
    response.fold(
      (l) {
        emit(GetMembersAttendanceFailState(message: l.message));
      },
      (r) {
        membersAttendanceList = r;
        if (membersAttendanceList.isEmpty) {
          emit(GetMembersAttendanceNoDataState());
        } else {
          emit(GetMembersAttendanceSuccessState());
        }
      },
    );
  }

//========================================================================

  final TextEditingController configReAttendController = TextEditingController();
  final TextEditingController waitingController = TextEditingController();

// ========================  CALENDER  ========================== //

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? firstDate;
  int? firstDateFormat;
  DateTime? lastDate;
  int? lastDateFormat;

  void pressFirstDate(context, {String memberId = "", required int status}) async {
    firstDate = await showDatePicker(
      context: context,
      initialDate: firstDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      lastDate: DateTime.now().add(const Duration(days: 360)),
    );

    if (firstDate != null) {
      firstDate = DateTime(firstDate!.year, firstDate!.month, firstDate!.day, 0, 0, 0);
      firstDateFormat = firstDate!.millisecondsSinceEpoch;
      startDateController.text = DateFormat('yyyy-MM-dd', "en").format(firstDate!);

      membersAttendanceCount(resetPage: false, status: status);
    }
    emit(UpdateFirstDateStates());
  }

  void pressLastDate(context, {required int status}) async {
    lastDate = await showDatePicker(
      context: context,
      initialDate: lastDate ?? firstDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      lastDate: DateTime.now().add(const Duration(days: 360)),
    );

    if (lastDate != null) {
      lastDate = DateTime(lastDate!.year, lastDate!.month, lastDate!.day, 23, 59, 59);
      lastDateFormat = lastDate!.millisecondsSinceEpoch;
      endDateController.text = DateFormat('yyyy-MM-dd', "en").format(lastDate!);

      membersAttendanceCount(resetPage: false, status: status);
    }
    emit(UpdateLastDateStates());
  }

//===================== SALARY ========================//

  final TextEditingController salaryTypeController = TextEditingController();
  int salaryId = -1;

  List<String> salaryList = [
    "الكل",
    "يومي",
    "شهري",
  ];

  void updateSalarySelected({required int id, required String name, required int status}) {
    salaryId = id;
    salaryTypeController.text = name;
    emit(ChangeSalaryState());
    membersAttendanceCount(status: status);
  }

//======================== CHANGE CAMERA ========================//

  bool frontCamera = Caching.get(key: AppConstance.cameraLensKey) == 1 || Caching.get(key: AppConstance.cameraLensKey) == null ? true : false;

  void changeFrontCamera() {
    frontCamera = !frontCamera;
    Caching.put(key: AppConstance.cameraLensKey, value: frontCamera ? 1 : 0);
    emit(ChangeFrontCameraState());
  }

  //=================== CACHED FACES =============================//

  final TextEditingController searchController = TextEditingController();

  List<FacesDetectionModel> cachedFacesList = [];
  List<FacesDetectionModel> filteredCachedFacesList = [];

  Future<void> loadCachedFaces() async {
    cachedFacesList = await Caching.getCachedFaceDetection();
    cachedFacesList = cachedFacesList.reversed.toList();
    filteredCachedFacesList = cachedFacesList;

    emit(LoadCachedFacesState());
  }

  Future<void> loadCachedFacesWithoutStore() async {
    cachedFacesList = await Caching.getCachedFaceDetection();

    emit(LoadCachedFacesState());
  }

  void searchCachedFaces(String query, {DateTime? date}) {
    if (query.isEmpty && date == null) {
      filteredCachedFacesList = List.from(cachedFacesList);
    } else {
      String normalizedQuery = normalizeText(query);
      filteredCachedFacesList = cachedFacesList.where((face) {
        bool matchesQuery = query.isEmpty ? true : normalizeText(face.memberName).contains(normalizedQuery);

        bool matchesDate = date == null ? true : isSameDate(DateTime.parse(face.createdAt), date);

        return matchesQuery && matchesDate;
      }).toList();
    }
    emit(LoadCachedFacesState());
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String normalizeText(String input) {
    return input.replaceAll(RegExp('[أإآ]'), 'ا').replaceAll('ة', 'ه').replaceAll('ى', 'ي');
  }

  int getUploadedCount() {
    return cachedFacesList.where((face) => face.uploadedToServer).length;
  }

  int getUnUploadedCount() {
    return cachedFacesList.where((face) => face.uploadedToServer == false).length;
  }

  // ======================== CACHED FACES CALENDER  ========================== //

  final TextEditingController facesDateController = TextEditingController();

  DateTime? date;

  void pressFacesDate(context) async {
    date = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      date = DateTime(date!.year, date!.month, date!.day);
      facesDateController.text = DateFormat('yyyy-MM-dd', "en").format(date!);
      emit(UpdateFirstDateStates());
      searchCachedFaces("", date: date);
    }
  }

  //===================================================

  void iniCachedData() {
    loadCachedFaces().whenComplete(() {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      facesDateController.text = DateFormat('yyyy-MM-dd', "en").format(date);
      emit(UpdateFirstDateStates());
      searchCachedFaces("", date: date);
    });
  }

  //===================================================

  WidgetStateProperty<Color>? getCachedDataColor({required bool uploadedToServer, required String serverReplay}) {
    if (uploadedToServer && serverReplay.isEmpty) {
      return WidgetStateProperty.all(AppColors.green.withOpacity(0.3));
    } else if (uploadedToServer && serverReplay.isNotEmpty) {
      return WidgetStateProperty.all(AppColors.yellow2);
    } else if (uploadedToServer == false) {
      return WidgetStateProperty.all(AppColors.red2);
    } else {
      return null;
    }
  }

  //===================== PICK FILE ========================//

  XFile? companyImage;
  String companyImageUploaded = "";

  void pickCompanyImageFile({
    required BuildContext context,
    required ImageSource source,
  }) async {
    companyImage = await ImagesService.pickFile(context: context, source: source);
    emit(PickedImageState());
  }

  // update image
  void updateMemberImageFile({
    required XFile image,
    required BuildContext context,
  }) async {
    companyImage = image;
    emit(PickedImageState());
  }

  void removeImageFile() async {
    companyImageUploaded = "";
    companyImage = null;
    emit(RemoveImageState());
  }

  //===================================================

  String version = "";

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    emit(LoadVersionState());
  }

  //=========================================================

  String livenessThreshold = "0.7";
  String identifyThreshold = "0.8";
  int selectedLivenessLevel = 0;

  final liveController = TextEditingController();
  final identifyController = TextEditingController();

  Future<void> loadSettings() async {
    dynamic livenessLevel = Caching.get(key: AppConstance.livenessLevelKey);
    dynamic livenessThreshold = Caching.get(key: AppConstance.identifyThresholdKey);
    dynamic identifyThreshold = Caching.get(key: AppConstance.identifyThresholdKey);

    livenessThreshold = livenessThreshold ?? "0.7";
    identifyThreshold = identifyThreshold ?? "0.8";
    selectedLivenessLevel = livenessLevel ?? 0;
    liveController.text = livenessThreshold;
    identifyController.text = identifyThreshold;
    emit(SettingsLoadedState());
  }

  Future<void> updateLivenessLevel(dynamic value) async {
    await Caching.get(key: AppConstance.identifyThresholdKey);
    Caching.put(key: AppConstance.livenessLevelKey, value: value);
  }

  Future<void> updateLivenessThreshold(BuildContext context) async {
    try {
      var doubleValue = double.parse(liveController.text);
      if (doubleValue >= 0 && doubleValue < 1.0) {
        await Caching.put(key: AppConstance.identifyThresholdKey, value: liveController.text);

        livenessThreshold = liveController.text;
        emit(UpdateLiveThresholdState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    MagicRouter.pop();
    liveController.text = livenessThreshold;
    emit(UpdateLiveThresholdState());
  }

  Future<void> updateIdentifyThreshold(BuildContext context) async {
    try {
      var doubleValue = double.parse(identifyController.text);
      if (doubleValue >= 0 && doubleValue < 1.0) {
        await Caching.put(key: AppConstance.identifyThresholdKey, value: identifyController.text);

        identifyThreshold = identifyController.text;
        emit(UpdateIdentifyThresholdState());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    MagicRouter.pop();
    identifyController.text = identifyThreshold;
    emit(UpdateIdentifyThresholdState());
  }

  void onSelectedItemChanged(int? selectedItem) {
    selectedLivenessLevel = selectedItem!;

    updateLivenessLevel(selectedItem);
    emit(ChangeLiveLevelState());
  }
}
