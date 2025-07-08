abstract class LogInStates {}

class AuthInitial extends LogInStates {}

class LogInLoadingState extends LogInStates {}

class LogInSuccessState extends LogInStates {}

class LogInFailState extends LogInStates {
  final String message;

  LogInFailState({required this.message});
}

class ChangeVisibilityState extends LogInStates {}

class ChanceBaseUrlState extends LogInStates {}
