import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:eventvista/app/shopease_app.dart';
import 'package:eventvista/utils/app_colors.dart';
import 'package:eventvista/utils/enums.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/configurations/app_config.dart';
import '../core/service/dependency_injection.dart' as di;
import 'flavor_config.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  FlavorConfig(
      flavor: Flavor.DEV, color: Colors.black38, flavorValues: FlavorValues());

  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.deviceOS == DeviceOS.ANDROID) {
    await Firebase.initializeApp();
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      log('Firebase : ${e.toString()}');
    }
  } else {}

  await di.setupLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.initColors().primaryOrange,
  ));

  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) {
        return ShopEase();
      },
    ),
  );
}
