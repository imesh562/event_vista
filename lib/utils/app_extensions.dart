import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

extension SHA256Ext on String {
  String getSHA256() {
    /*var bytes = utf8.encode(this); // Convert the string to bytes
    var sha256Result = sha256.convert(bytes); // Generate the SHA256 hash
    var hash = sha256Result.toString(); // Convert the hash to a string
    return hash;*/
    return this;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }
}

extension DeviceOSExt on DeviceOS {
  String getValue() {
    if (Platform.isIOS)
      return "IOS";
    else
      return this.toString().split(".").last;
  }
}

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}
