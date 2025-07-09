abstract class EmployeesStates {}

class EmployeesInitialState extends EmployeesStates {}

//========================= GET EMPLOYEES ===========================//

class GetCountSuccessState extends EmployeesStates {}

class GetEmployeesLoadingState extends EmployeesStates {}

class GetEmployeesSuccessState extends EmployeesStates {}

class GetEmployeesNoDataState extends EmployeesStates {}

class GetEmployeesFailState extends EmployeesStates {
  final String message;

  GetEmployeesFailState({required this.message});
}

//========================= ADD EMPLOYEES ===========================//

class AddEmployeesLoadingState extends EmployeesStates {}

class AddEmployeesSuccessState extends EmployeesStates {
  final String? message;
  final int statusCode;

  AddEmployeesSuccessState({required this.statusCode, this.message});
}

class AddEmployeesFailState extends EmployeesStates {
  final String message;

  AddEmployeesFailState({required this.message});
}

//=========================  DELETE EMPLOYEES ===========================//

class DeleteEmployeesLoadingState extends EmployeesStates {}

class DeleteEmployeesSuccessState extends EmployeesStates {}

class DeleteEmployeesFailState extends EmployeesStates {
  final String message;

  DeleteEmployeesFailState({required this.message});
}

//========================= GET SUBJECTS ===========================//

class GetSubjectsLoadingState extends EmployeesStates {}

class GetSubjectsSuccessState extends EmployeesStates {}

class GetSubjectsNoDataState extends EmployeesStates {}

class GetSubjectsFailState extends EmployeesStates {
  final String message;

  GetSubjectsFailState({required this.message});
}

//=============================================================

class PickedImageState extends EmployeesStates {}

class ChangePageState extends EmployeesStates {}

class ChangeCachedPeopleState extends EmployeesStates {}

class ChangeSubjectState extends EmployeesStates {}

class EmployeesSelectionChangedState extends EmployeesStates {}
