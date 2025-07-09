import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_attend_recognition/features/home/data/models/faces_detection_model.dart';
import 'package:time_attend_recognition/features/home/data/models/profile_model.dart';
import 'package:time_attend_recognition/features/members/data/models/employees_model.dart';

import '../utils/lang.dart';

class Caching {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static put({
    required String key,
    required dynamic value,
  }) async {
    if (value is int) return await prefs?.setInt(key, value);
    if (value is bool) return await prefs?.setBool(key, value);
    if (value is double) return await prefs?.setDouble(key, value);
    if (value is String) return await prefs?.setString(key, value);
  }

  static get({required String key}) {
    return prefs?.get(key);
  }

  static removeData({required String key}) {
    return prefs?.remove(key);
  }

  static Future<void> clearAllData() async {
    await prefs?.clear();
  }

  //===============================  CACHING PROFILE DATA ================================//

  static ProfileModel? getProfile() {
    String? profilePref = prefs?.getString("profile");
    if (profilePref == null) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(profilePref) as Map<String, dynamic>;
    return ProfileModel.fromJson(userMap);
  }

  static Future<void> setProfile(ProfileModel model) async {
    await prefs?.setString("profile", jsonEncode(model.toJson()));
  }

  //===================================  CACHING EMPLOYEES ================================//

  static Future<bool>? cacheEmployees({required List<EmployeesModel> employees}) {
    List<String> jsonStringList = employees.map((model) => json.encode(model.toJson())).toList();
    return prefs?.setStringList(
      "employeesListKey",
      jsonStringList,
    );
  }

  static Future<List<EmployeesModel>> getCachedEmployees() async {
    final List<String>? jsonStringList = prefs?.getStringList("employeesListKey");
    if (jsonStringList == null) return [];

    List<EmployeesModel> models = jsonStringList.map((jsonString) {
      return EmployeesModel.fromJson(json.decode(jsonString));
    }).toList();
    return models;
  }

  //===================================  CACHING FACE DETECTION ================================//

  static Future<bool>? cacheFaceDetection({required List<FacesDetectionModel> faces}) {
    List<String> jsonStringList = faces.map((model) => json.encode(model.toJson())).toList();
    return prefs?.setStringList(
      "face_detection",
      jsonStringList,
    );
  }

  static Future<List<FacesDetectionModel>> getCachedFaceDetection() async {
    final List<String>? jsonStringList = prefs?.getStringList("face_detection");
    if (jsonStringList == null) return [];

    List<FacesDetectionModel> models = jsonStringList.map((jsonString) {
      return FacesDetectionModel.fromJson(json.decode(jsonString));
    }).toList();
    return models;
  }

  //===================================  CACHING LANGUAGE ================================//

  static String getAppLang() {
    String? lang = prefs?.getString("language");
    if (lang != null && lang.isNotEmpty) {
      return lang;
    } else {
      return LanguageType.arabic.getValue;
    }
  }

  static Future<void> changeAppLang() async {
    String currentLang = getAppLang();
    if (currentLang == LanguageType.arabic.getValue) {
      await prefs?.setString("language", LanguageType.english.getValue);
    } else {
      await prefs?.setString("language", LanguageType.arabic.getValue);
    }
  }

  static Future<Locale> getLocal() async {
    String currentLang = getAppLang();
    if (currentLang == LanguageType.arabic.getValue) {
      return arabicLocal;
    } else {
      return englishLocal;
    }
  }
}
