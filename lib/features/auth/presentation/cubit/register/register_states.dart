abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

// ====================== REGISTER ===================== //

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterFailState extends RegisterStates {
  final String message;

  RegisterFailState({required this.message});
}

// ====================== SEND CODE ===================== //

class SendCodeLoadingState extends RegisterStates {}

class SendCodeSuccessState extends RegisterStates {}

class SendCodeFailState extends RegisterStates {
  final String message;

  SendCodeFailState({required this.message});
}

//===================== CHECK USERNAME ========================//

class CheckUserLoadingState extends RegisterStates {}

class CheckUserSuccessState extends RegisterStates {}

class CheckUserFailState extends RegisterStates {
  final String message;

  CheckUserFailState({required this.message});
}

// ============================================================

class ChangeNumberState extends RegisterStates {}

class LogChangeObscureTextState extends RegisterStates {}

class LogChangeVisibilityState extends RegisterStates {}

class PickedImageState extends RegisterStates {}

class SelectGenderState extends RegisterStates {}
