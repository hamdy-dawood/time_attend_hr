abstract class UsersEmployeesStates {}

class UsersEmployeesInitialState extends UsersEmployeesStates {}

//========================= GET USERS EMPLOYEE ===========================//

class GetCountSuccessState extends UsersEmployeesStates {}

class GetUsersEmployeesLoadingState extends UsersEmployeesStates {}

class GetUsersEmployeesSuccessState extends UsersEmployeesStates {}

class GetUsersEmployeesNoDataState extends UsersEmployeesStates {}

class GetUsersEmployeesFailState extends UsersEmployeesStates {
  final String message;

  GetUsersEmployeesFailState({required this.message});
}

//========================= ADD USERS EMPLOYEE ===========================//

class AddUsersEmployeesLoadingState extends UsersEmployeesStates {}

class AddUsersEmployeesSuccessState extends UsersEmployeesStates {}

class AddUsersEmployeesFailState extends UsersEmployeesStates {
  final String message;

  AddUsersEmployeesFailState({required this.message});
}

//=========================  DELETE USERS EMPLOYEE ===========================//

class DeleteUsersEmployeesLoadingState extends UsersEmployeesStates {}

class DeleteUsersEmployeesSuccessState extends UsersEmployeesStates {}

class DeleteUsersEmployeesFailState extends UsersEmployeesStates {
  final String message;

  DeleteUsersEmployeesFailState({required this.message});
}

//=============================================================

class PickedImageState extends UsersEmployeesStates {}

class ChangePageState extends UsersEmployeesStates {}

class ChanceUsersEmployeePasswordVisibilityState extends UsersEmployeesStates {}

class ChangePermissionsState extends UsersEmployeesStates {}
