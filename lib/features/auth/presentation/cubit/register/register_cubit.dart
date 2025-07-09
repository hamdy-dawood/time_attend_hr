import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/logger.dart';
import 'package:time_attend_recognition/core/caching/shared_prefs.dart';

import '../../../domain/repository/base_auth_repository.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final BaseAuthRepository repo;

  RegisterCubit(this.repo) : super(RegisterInitial());

  static RegisterCubit of(BuildContext context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  // ====================== REGISTER ===================== //

  String role = "employee";

  Future register() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());

      final response = await repo.register(
        userName: userNameController.text,
        password: passwordController.text,
        companyName: companyNameController.text,
        role: role,
      );
      response.fold(
        (l) {
          emit(RegisterFailState(message: l.message));
          Logger().e(l.message);
        },
        (r) {
          Caching.put(key: "access_token", value: r.accessToken);
          // Caching.put(key: "refresh_token", value: r.refreshToken);
          emit(RegisterSuccessState());
        },
      );
    }
  }

//===================== CHECK USERNAME ========================//

  bool isUsernameAvailable = true;

  Future<void> checkUsername() async {
    emit(CheckUserLoadingState());

    final response = await repo.checkUsername(
      username: userNameController.text,
    );
    response.fold(
      (l) {
        emit(CheckUserFailState(message: l.message));
      },
      (r) {
        isUsernameAvailable = r;
        emit(CheckUserSuccessState());
      },
    );
  }

  // ====================== SEND CODE ===================== //

  String? verificationId;

  Future<void> sendCode() async {
    emit(SendCodeLoadingState());

    final response = await repo.sendCode(
      phone: phoneNumber,
    );
    response.fold(
      (l) {
        emit(SendCodeFailState(message: l.message));
      },
      (r) {
        if (r == null) {
          emit(SendCodeFailState(message: "blocked_phone".tr()));
        } else {
          verificationId = r;
          emit(SendCodeSuccessState());
        }
      },
    );
  }

  Future<void> reSendCode() async {
    emit(SendCodeLoadingState());

    final response = await repo.reSendCode(
      phone: phoneNumber,
    );
    response.fold((l) {
      emit(SendCodeFailState(message: l.message));
    }, (r) {
      emit(SendCodeSuccessState());
    });
  }

  // ===========================================================================

  String phoneNumber = "";

  onInputChanged(PhoneNumber phone) {
    phoneNumber = "${phone.countryCode}${phone.number}";
    emit(ChangeNumberState());
  }

  // ===========================================================================

  bool isObscure = true;

  void changeVisibility() {
    isObscure = !isObscure;
    emit(LogChangeVisibilityState());
  }
}
