import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_attend_recognition/core/helper/uploads_images.dart';

import '../../domain/entities/add_users_employee_request_body.dart';
import '../../domain/entities/users_employees_entity.dart';
import '../../domain/repositories/base_users_repository.dart';
import 'users_states.dart';

class UsersEmployeesCubit extends Cubit<UsersEmployeesStates> {
  final BaseUsersEmployeesRepository baseUsersEmployeesRepository;

  UsersEmployeesCubit(this.baseUsersEmployeesRepository) : super(UsersEmployeesInitialState());

  //========================= GET COUNT ===========================//

  int count = 0;

  Future<void> getCount() async {
    emit(GetUsersEmployeesLoadingState());

    final response = await baseUsersEmployeesRepository.count();
    response.fold(
      (l) => emit(GetUsersEmployeesFailState(message: l.message)),
      (r) {
        count = r;
        getUsersEmployees();
        emit(GetCountSuccessState());
      },
    );
  }

  //========================= USERS EMPLOYEE ========================//

  final GlobalKey<FormState> usersEmployeesFormKey = GlobalKey<FormState>();

  final TextEditingController searchController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //========================= GET USERS EMPLOYEE ===========================//

  List<UsersEmployeesEntity> usersEmployeesList = [];
  int page = 0;

  Future<void> getUsersEmployees() async {
    emit(GetUsersEmployeesLoadingState());

    final response = await baseUsersEmployeesRepository.getUsersEmployees(
      skip: page,
      searchText: searchController.text,
    );
    response.fold(
      (l) {
        emit(GetUsersEmployeesFailState(message: l.message));
      },
      (r) {
        usersEmployeesList = r;
        if (usersEmployeesList.isEmpty) {
          emit(GetUsersEmployeesNoDataState());
        } else {
          emit(GetUsersEmployeesSuccessState());
        }
      },
    );
  }

  //========================= ADD USERS EMPLOYEE ===========================//

  XFile? usersEmployeeImage;
  String usersEmployeeImageUploaded = "";

  Future<void> addUsersEmployees() async {
    if (usersEmployeesFormKey.currentState!.validate()) {
      emit(AddUsersEmployeesLoadingState());

      try {
        if (usersEmployeeImage != null) {
          if (kIsWeb) {
            usersEmployeeImageUploaded = await ImagesService.uploadImageWeb(usersEmployeeImage!);
          } else {
            usersEmployeeImageUploaded = await ImagesService.uploadImage(usersEmployeeImage!.path);
          }
        }
      } on Exception catch (e) {
        emit(AddUsersEmployeesFailState(message: e.toString()));
        return;
      }

      final response = await baseUsersEmployeesRepository.addUsersEmployees(
        addUsersEmployeeRequestBody: AddUsersEmployeeRequestBody(
          displayName: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          image: usersEmployeeImageUploaded,
          permissions: AddUsersEmployeePermissions(
            showEmployeesPage: showEmployeesPage,
            showAttendancePage: showAttendancePage,
            showAttendanceReportPage: showAttendanceReportPage,
            showFullReportPage: showFullReportPage,
            showProjectsPage: showProjectsPage,
            showHolidaysPage: showHolidaysPage,
            canRecognize: canRecognize,
            canAdd: canAdd,
            canEdit: canEdit,
            canDelete: canDelete,
          ),
        ),
      );
      response.fold(
        (l) {
          emit(AddUsersEmployeesFailState(message: l.message));
        },
        (r) => emit(AddUsersEmployeesSuccessState()),
      );
    }
  }

  Future<void> editUsersEmployees({required String id}) async {
    emit(AddUsersEmployeesLoadingState());

    try {
      if (usersEmployeeImage != null) {
        if (kIsWeb) {
          usersEmployeeImageUploaded = await ImagesService.uploadImageWeb(usersEmployeeImage!);
        } else {
          usersEmployeeImageUploaded = await ImagesService.uploadImage(usersEmployeeImage!.path);
        }
      }
    } on Exception catch (e) {
      emit(AddUsersEmployeesFailState(message: e.toString()));
      return;
    }

    final response = await baseUsersEmployeesRepository.editUsersEmployees(
      addUsersEmployeeRequestBody: AddUsersEmployeeRequestBody(
        id: id,
        displayName: nameController.text,
        username: usernameController.text,
        password: passwordController.text,
        image: usersEmployeeImageUploaded,
        permissions: AddUsersEmployeePermissions(
          showEmployeesPage: showEmployeesPage,
          showAttendancePage: showAttendancePage,
          showAttendanceReportPage: showAttendanceReportPage,
          showFullReportPage: showFullReportPage,
          showProjectsPage: showProjectsPage,
          showHolidaysPage: showHolidaysPage,
          canRecognize: canRecognize,
          canAdd: canAdd,
          canEdit: canEdit,
          canDelete: canDelete,
        ),
      ),
    );
    response.fold(
      (l) {
        emit(AddUsersEmployeesFailState(message: l.message));
      },
      (r) => emit(AddUsersEmployeesSuccessState()),
    );
  }

  //===================== DELETE USERS EMPLOYEE ========================//

  Future<void> deleteUsersEmployees({required String id}) async {
    emit(DeleteUsersEmployeesLoadingState());

    final response = await baseUsersEmployeesRepository.deleteUsersEmployees(id: id);
    response.fold(
      (l) => emit(DeleteUsersEmployeesFailState(message: l.message)),
      (r) => emit(DeleteUsersEmployeesSuccessState()),
    );
  }

  //===================== PICK FILE ========================//

  void pickMemberImageFile({
    required BuildContext context,
    required ImageSource source,
  }) async {
    usersEmployeeImage = await ImagesService.pickFile(context: context, source: source);
    emit(PickedImageState());
  }

  //==========================================================

  bool usersEmployeePasswordObscure = true;

  usersEmployeeVisibility() {
    usersEmployeePasswordObscure = !usersEmployeePasswordObscure;
    emit(ChanceUsersEmployeePasswordVisibilityState());
  }

//==========================================================

  bool showEmployeesPage = true;
  bool showAttendancePage = true;
  bool showAttendanceReportPage = true;
  bool showFullReportPage = true;
  bool showProjectsPage = true;
  bool showHolidaysPage = true;
  bool canRecognize = true;
  bool canAdd = true;
  bool canEdit = true;
  bool canDelete = true;

  void changeShowEmployees() {
    showEmployeesPage = !showEmployeesPage;
    emit(ChangePermissionsState());
  }

  void changeShowAttendance() {
    showAttendancePage = !showAttendancePage;
    emit(ChangePermissionsState());
  }

  void changeShowAttendanceReportPage() {
    showAttendanceReportPage = !showAttendanceReportPage;
    emit(ChangePermissionsState());
  }

  void changeShowFullReport() {
    showFullReportPage = !showFullReportPage;
    emit(ChangePermissionsState());
  }

  void changeShowProjects() {
    showProjectsPage = !showProjectsPage;
    emit(ChangePermissionsState());
  }

  void changeShowHolidays() {
    showHolidaysPage = !showHolidaysPage;
    emit(ChangePermissionsState());
  }

  void changeCanAdd() {
    canAdd = !canAdd;
    emit(ChangePermissionsState());
  }

  void changeCanRecognize() {
    canRecognize = !canRecognize;
    emit(ChangePermissionsState());
  }

  void changeCanEdit() {
    canEdit = !canEdit;
    emit(ChangePermissionsState());
  }

  void changeCanDelete() {
    canDelete = !canDelete;
    emit(ChangePermissionsState());
  }
}
