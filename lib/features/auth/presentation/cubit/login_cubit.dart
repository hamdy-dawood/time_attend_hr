import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';
import 'package:time_attend_recognition/core/network/dio.dart';

import '../../domain/repository/base_auth_repository.dart';
import 'login_states.dart';

class LogInCubit extends Cubit<LogInStates> {
  final BaseAuthRepository repo;

  LogInCubit(this.repo) : super(AuthInitial());

  static LogInCubit of(BuildContext context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // ====================== LOGIN ===================== //

  String role = "admin";

  Future login() async {
    if (formKey.currentState!.validate()) {
      emit(LogInLoadingState());

      final response = await repo.login(
        userName: userNameController.text,
        password: passwordController.text,
        role: role,
      );
      response.fold(
        (l) {
          emit(LogInFailState(message: l.message));
          Logger().e(l.message);
        },
        (r) {
          Caching.put(key: "access_token", value: r.accessToken);
          // Caching.put(key: "refresh_token", value: r.refreshToken);
          emit(LogInSuccessState());
        },
      );
    }
  }

// *************************************

  bool isObscure = true;

  void changeVisibility() {
    isObscure = !isObscure;
    emit(ChangeVisibilityState());
  }

//=========================================================================

  TextEditingController urlController = TextEditingController();

  Future<void> setBaseUrl() async {
    Caching.put(
      key: "cached_url",
      value: urlController.text,
    );
    DioManager().setBaseUrl(urlController.text);
    emit(ChanceBaseUrlState());
  }
}
