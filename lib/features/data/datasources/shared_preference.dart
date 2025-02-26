import 'dart:convert';

import 'package:eventvista/features/data/models/responses/user_data_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _APP_TOKEN = 'app_token';
const String _PUSH_TOKEN = 'push_token';
const String _AUTH_USER = 'auth_user';

class AppSharedData {
  late SharedPreferences secureStorage;

  AppSharedData(SharedPreferences preferences) {
    secureStorage = preferences;
  }

  ///APP TOKEN
  bool hasAppToken() {
    return secureStorage.containsKey(_APP_TOKEN);
  }

  setAppToken(String token) {
    secureStorage.setString(_APP_TOKEN, token);
  }

  String? getAppToken() {
    if (secureStorage.containsKey(_APP_TOKEN)) {
      return secureStorage.getString(_APP_TOKEN);
    } else {
      return "";
    }
  }

  clearAppToken() {
    secureStorage.remove(_APP_TOKEN);
  }

  ///PUSH TOKEN
  setPushToken(String token) {
    secureStorage.setString(_PUSH_TOKEN, token);
  }

  bool hasPushToken() {
    return secureStorage.containsKey(_PUSH_TOKEN);
  }

  String? getPushToken() {
    if (secureStorage.containsKey(_PUSH_TOKEN)) {
      return secureStorage.getString(_PUSH_TOKEN);
    } else {
      return "";
    }
  }

  clearPushToken() {
    secureStorage.remove(_PUSH_TOKEN);
  }

  ///Auth User Data
  setAuthUser(UserData authUser) {
    secureStorage.setString(_AUTH_USER, jsonEncode(authUser.toJson()));
  }

  bool hasAuthUser() {
    return secureStorage.containsKey(_AUTH_USER);
  }

  UserData getAuthUser() {
    return UserData.fromJson(jsonDecode(secureStorage.getString(_AUTH_USER)!));
  }

  removeAuthUser() {
    secureStorage.remove(_AUTH_USER);
  }
}
