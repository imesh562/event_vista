import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/configurations/app_config.dart';
import 'enums.dart';

class AppUtils {
  static TimeOfDay getTimeFromString(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1].split(' ')[0]));
  }

  static String convertTimeOfDayToAPIFormat(TimeOfDay value) {
    return '${value.hour}:${value.minute}:00';
  }

  static String convertTimeToAPIFormat(String value) {
    final time = getTimeFromString(value);
    return convertTimeOfDayToAPIFormat(time);
  }

  static String convertToCurrency(double amount,
      {bool shouldAddSymbol = true}) {
    return '${shouldAddSymbol ? 'Rs ' : ''}${NumberFormat.currency(symbol: '').format(amount)}';
  }

  static int getOSType() {
    if (AppConfig.deviceOS == DeviceOS.HUAWEI) {
      return 3;
    } else {
      if (Platform.isIOS) {
        return 2;
      } else {
        return 1;
      }
    }
  }

  static int _daysInMonth(int month) {
    if (month == 2) {
      return 29;
    }
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }
}
