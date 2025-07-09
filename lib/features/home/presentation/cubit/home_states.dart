import 'package:time_attend_recognition/features/members/data/models/employees_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

//========================= GET PROFILE ===========================//

class GetProfileLoadingState extends HomeStates {}

class GetProfileSuccessState extends HomeStates {}

class GetProfileFailState extends HomeStates {
  final String message;

  GetProfileFailState({required this.message});
}

//========================= ACTIVATION ===========================//

class ActivationSuccessState extends HomeStates {}

class ActivationFailState extends HomeStates {
  final String message;

  ActivationFailState({required this.message});
}

//========================= CHANGE PASSWORD ===========================//

class ChangePasswordLoadingState extends HomeStates {}

class ChangePasswordSuccessState extends HomeStates {}

class ChangePasswordFailState extends HomeStates {
  final String message;

  ChangePasswordFailState({required this.message});
}

//========================= EDIT PROFILE ===========================//

class EditProfileLoadingState extends HomeStates {}

class EditProfileSuccessState extends HomeStates {}

class EditProfileFailState extends HomeStates {
  final String message;

  EditProfileFailState({required this.message});
}

//========================= GET HOME COUNT ===========================//

class GetHomeCountLoadingState extends HomeStates {}

class GetHomeCountSuccessState extends HomeStates {}

class GetHomeCountFailState extends HomeStates {
  final String message;

  GetHomeCountFailState({required this.message});
}

//========================= CHECK ATTENDANCE ===========================//

class ReCheckAttendanceNoInternetConnectionState extends HomeStates {}

class ReUploadCheckAttendanceLoadingState extends HomeStates {}

class CachedDataSuccessState extends HomeStates {
  final EmployeesModel employee;

  CachedDataSuccessState({required this.employee});
}

class ReUploadCheckAttendanceFailState extends HomeStates {
  final String message;
  final bool wantPop;

  ReUploadCheckAttendanceFailState({required this.message, required this.wantPop});
}

class ReUploadCheckAttendanceSuccessState extends HomeStates {
  final bool wantPop;

  ReUploadCheckAttendanceSuccessState({required this.wantPop});
}

//========================= GET MEMBERS ATTENDANCE ===========================//

class GetMembersAttendanceCountSuccessState extends HomeStates {}

class GetMembersAttendanceLoadingState extends HomeStates {}

class GetMembersAttendanceNoDataState extends HomeStates {}

class GetMembersAttendanceSuccessState extends HomeStates {}

class GetMembersAttendanceFailState extends HomeStates {
  final String message;

  GetMembersAttendanceFailState({required this.message});
}

///========================= FINGERPRINT ===========================//

class MakeFingerprintLoadingState extends HomeStates {}

class MakeFingerprintSuccessState extends HomeStates {
  final String name;

  MakeFingerprintSuccessState({required this.name});
}

class MakeFingerprintFailState extends HomeStates {
  final String message;

  MakeFingerprintFailState({required this.message});
}

//================================================================================

class UpdateFirstDateStates extends HomeStates {}

class UpdateLastDateStates extends HomeStates {}

class ChangeSalaryState extends HomeStates {}

class ChangeFrontCameraState extends HomeStates {}

class ClosedTimeState extends HomeStates {}

class LoadCachedFacesState extends HomeStates {}

class ChangeOldVisibilityState extends HomeStates {}

class ChangeNewVisibilityState extends HomeStates {}

class LoadVersionState extends HomeStates {}

class PickedImageState extends HomeStates {}

class RemoveImageState extends HomeStates {}

class ErrorState extends HomeStates {
  final String message;

  ErrorState({required this.message});
}

class SettingsLoadedState extends HomeStates {}

class UpdateLiveThresholdState extends HomeStates {}

class UpdateIdentifyThresholdState extends HomeStates {}

class ChangeLiveLevelState extends HomeStates {}
