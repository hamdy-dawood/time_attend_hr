import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/widget/overlay_loading.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:time_attend_recognition/features/face_recognize/face_detection_class.dart';
import 'package:time_attend_recognition/features/members/data/models/employees_model.dart';
import 'package:toastification/toastification.dart';

import '../../domain/entities/add_employees_request_body.dart';
import '../../domain/entities/employees_entity.dart';
import '../../domain/entities/subjects_entity.dart';
import '../../domain/repositories/base_employees_repository.dart';
import 'employees_states.dart';

class EmployeesCubit extends Cubit<EmployeesStates> {
  final BaseEmployeesRepository baseMembersRepository;

  EmployeesCubit(this.baseMembersRepository) : super(EmployeesInitialState());

  //========================= EMPLOYEES ========================//

  final GlobalKey<FormState> employeesFormKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  XFile? employeeImage;
  String employeeImageUploaded = "";

  //========================= GET EMPLOYEES ===========================//

  List<EmployeesEntity> employeesList = [];

  GetCategoryData getData = GetCategoryData.none;

  Future<void> getEmployees() async {
    emit(GetEmployeesLoadingState());

    getData = GetCategoryData.loading;

    final response = await baseMembersRepository.getEmployees(
      searchText: searchController.text,
    );
    response.fold(
      (l) {
        getData = GetCategoryData.fail;
        emit(GetEmployeesFailState(message: l.message));
      },
      (r) {
        employeesList = r;
        getData = GetCategoryData.success;
        if (employeesList.isEmpty) {
          emit(GetEmployeesNoDataState());
        } else {
          MdSoftFaceDetection.personList = r;
          Caching.cacheEmployees(employees: r.map((entity) => EmployeesModel.fromEntity(entity)).toList());
          emit(GetEmployeesSuccessState());
        }
      },
    );
  }

  //========================= ADD EMPLOYEES ===========================//

  Future<void> addMembers() async {
    if (employeesFormKey.currentState!.validate()) {
      emit(AddEmployeesLoadingState());

      // try {
      //   if (employeeImage != null) {
      //     Uint8List imageBytes = await employeeImage!.readAsBytes();
      //
      //     // Convert to Base64
      //     employeeImageUploaded = base64Encode(imageBytes);
      //   }
      // } catch (e) {
      //   log('Error converting image to Base64: $e');
      // }

      final response = await baseMembersRepository.addEmployees(
        addMembersRequestBody: AddEmployeesRequestBody(
          displayName: nameController.text,
          image: employeeImageUploaded,
          faceId: template,
        ),
      );
      response.fold(
        (l) => emit(AddEmployeesFailState(message: l.message)),
        (r) {
          addToCache(person: EmployeesModel.fromEntity(r));
          emit(AddEmployeesSuccessState(statusCode: 200));
        },
      );
    }
  }

  Future<void> editMembers({required String id}) async {
    if (employeesFormKey.currentState!.validate()) {
      emit(AddEmployeesLoadingState());

      // try {
      //   if (employeeImage != null) {
      //     if (kIsWeb) {
      //       employeeImageUploaded = await ImagesService.uploadImageWeb(employeeImage!);
      //     } else {
      //       employeeImageUploaded = await ImagesService.uploadImage(employeeImage!.path);
      //     }
      //   }
      // } on Exception catch (e) {
      //   emit(AddEmployeesFailState(message: e.toString()));
      //   return;
      // }

      final response = await baseMembersRepository.editEmployees(
        addMembersRequestBody: AddEmployeesRequestBody(
          id: id,
          displayName: nameController.text,
          image: employeeImageUploaded,
          faceId: template,
        ),
      );
      response.fold(
        (l) => emit(AddEmployeesFailState(message: l.message)),
        (r) {
          editInCache(person: EmployeesModel.fromEntity(r), id: id);
          emit(AddEmployeesSuccessState(statusCode: 200));
        },
      );
    }
  }

  //===================== DELETE EMPLOYEES ========================//

  Future<void> deleteMembers({required String id}) async {
    emit(DeleteEmployeesLoadingState());

    final response = await baseMembersRepository.deleteEmployees(id: id);
    response.fold(
      (l) => emit(DeleteEmployeesFailState(message: l.message)),
      (r) {
        removeFromCache(id: id);
        emit(DeleteEmployeesSuccessState());
      },
    );
  }

  // =========================== ENROLL PERSON IMAGE ===========================//

  dynamic template;

  Future<void> choosePersonImage({
    required ImageSource source,
    required BuildContext context,
    required String editPersonId,
  }) async {
    final image = await ImagePicker().pickImage(source: source, imageQuality: 100);
    if (image == null) return;

    OverlayLoadingProgress.start(context);

    int maxSizeInBytes = 3 * 1024 * 1024; // 3MB
    XFile compressedImage = await _compressImage(image, maxSizeInBytes);

    int imageSize = await compressedImage.length();
    debugPrint("Compressed imageSize: $imageSize");

    if (imageSize <= maxSizeInBytes) {
      final Map<String, dynamic> enrollPerson = await MdSoftFaceDetection.enrollPerson(
        image: compressedImage,
        editPersonId: editPersonId,
      );

      if (enrollPerson["status"] == true) {
        employeeImage = compressedImage;
        template = enrollPerson["template"];
        MagicRouter.pop();
        OverlayLoadingProgress.stop();
        showToastificationWidget(
          context: context,
          message: enrollPerson["message"],
          notificationType: ToastificationType.success,
        );
        emit(PickedImageState());
      } else {
        showToastificationWidget(
          context: context,
          message: enrollPerson["message"],
        );
        OverlayLoadingProgress.stop();
      }
    } else {
      showToastificationWidget(
        context: context,
        message: "حجم الصورة كبيرة جدًا",
      );
      OverlayLoadingProgress.stop();
    }
  }

  Future<XFile> _compressImage(XFile image, int maxSizeInBytes) async {
    // Get the image bytes
    final imageBytes = await image.readAsBytes();

    // Compress the image
    var result = await FlutterImageCompress.compressWithList(
      imageBytes,
      minWidth: 1024,
      minHeight: 1024,
      quality: 85,
    );

    // Check if the compressed image is still larger than the max size
    if (result.length > maxSizeInBytes) {
      // Further compress the image by reducing quality
      result = await FlutterImageCompress.compressWithList(
        result,
        quality: 50, // Further reduce quality
      );
    }

    // Save the compressed image to a temporary file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image-${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(result);

    return XFile(file.path);
  }

  //============ GET CACHED EMPLOYEES ==========//

  Future<void> getCachedEmployees() async {
    cachedDocumentsList = await Caching.getCachedEmployees();
    MdSoftFaceDetection.personList = cachedDocumentsList;
    emit(ChangeCachedPeopleState());
  }

  //============ ADD TO CACHE ==========//

  List<EmployeesModel> cachedDocumentsList = [];

  Future<void> addToCache({required EmployeesModel person}) async {
    cachedDocumentsList = await Caching.getCachedEmployees();
    cachedDocumentsList.add(person);
    Caching.cacheEmployees(employees: cachedDocumentsList);

    MdSoftFaceDetection.personList = cachedDocumentsList;
    emit(ChangeCachedPeopleState());
  }

  //============ EDIT IN CACHE ==========//

  Future<void> editInCache({
    required String id,
    required EmployeesModel person,
  }) async {
    cachedDocumentsList = await Caching.getCachedEmployees();
    cachedDocumentsList.removeWhere((EmployeesModel document) => document.id == id);
    cachedDocumentsList.add(person);
    Caching.cacheEmployees(employees: cachedDocumentsList);

    MdSoftFaceDetection.personList = cachedDocumentsList;
    emit(ChangeCachedPeopleState());
  }

  //============ REMOVE FROM CACHE ==========//

  Future<void> removeFromCache({required String id}) async {
    cachedDocumentsList = await Caching.getCachedEmployees();
    cachedDocumentsList.removeWhere((EmployeesModel document) => document.id == id);
    Caching.cacheEmployees(employees: cachedDocumentsList);

    MdSoftFaceDetection.personList = cachedDocumentsList;
    emit(ChangeCachedPeopleState());
  }

  //========================= GET SUBJECTS ===========================//

  List<SubjectsEntity> subjectsList = [];

  Future<void> getSubjects({required String enrollId}) async {
    emit(GetSubjectsLoadingState());

    final response = await baseMembersRepository.getSubjects(
      enrollId: enrollId,
    );
    response.fold(
      (l) {
        emit(GetSubjectsFailState(message: l.message));
      },
      (r) {
        subjectsList = r;
        if (subjectsList.isEmpty) {
          emit(GetSubjectsNoDataState());
        } else {
          emit(GetSubjectsSuccessState());
        }
      },
    );
  }

  String? selectedSubjectName;
  String? selectedSubjectCode;

  void updateSubjectSelected({
    required SubjectsEntity subjectEntity,
  }) {
    selectedSubjectName = subjectEntity.name;
    selectedSubjectCode = subjectEntity.code;
    emit(ChangeSubjectState());
  }

  ///===================== MULTI SELECT EMPLOYEE ====================//

  late PageController pageController;

  List<EmployeesEntity> selectedEmployees = [];
  List<EmployeesEntity> attendSelectedEmployees = [];
  List<EmployeesEntity> absentSelectedEmployees = [];

  void attendEmployeeSelection(String id) {
    final employee = employeesList.firstWhere((e) => e.id == id);

    // Add to selected if not already present
    if (!selectedEmployees.any((e) => e.id == id)) {
      selectedEmployees.add(employee);
    }

    // Add to attend list if not already present
    if (!attendSelectedEmployees.any((e) => e.id == id)) {
      attendSelectedEmployees.add(employee);
    }

    // Remove from absent list if present
    absentSelectedEmployees.removeWhere((e) => e.id == id);

    emit(EmployeesSelectionChangedState());
  }

  void absentEmployeeSelection(String id) {
    final employee = employeesList.firstWhere((e) => e.id == id);

    // Add to selected if not already present
    if (!selectedEmployees.any((e) => e.id == id)) {
      selectedEmployees.add(employee);
    }

    // Add to absent list if not already present
    if (!absentSelectedEmployees.any((e) => e.id == id)) {
      absentSelectedEmployees.add(employee);
    }

    // Remove from attend list if present
    attendSelectedEmployees.removeWhere((e) => e.id == id);

    emit(EmployeesSelectionChangedState());
  }
}

enum GetCategoryData { none, loading, success, fail }
