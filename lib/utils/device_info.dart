import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  var release, sdkInt, manufacturer, model;
  var systemName, version, name;

  initDeviceInfo() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      release = androidInfo.version.release;
      sdkInt = androidInfo.version.sdkInt;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      systemName = iosInfo.systemName;
      version = iosInfo.systemVersion;
      name = iosInfo.name;
      model = iosInfo.model;
    }
  }

  String getMobileManufacture() {
    if (Platform.isAndroid)
      return manufacturer;
    else
      return 'Apple';
  }

  String getMobileOS() {
    if (Platform.isAndroid) {
      return 'Android $release';
    } else {
      return systemName;
    }
  }

  String getModel() {
    return model;
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
  }
}
