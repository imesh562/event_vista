import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/service/dependency_injection.dart';
import '../core/service/local_push_manager.dart';
import '../features/data/datasources/shared_preference.dart';
import '../flavors/flavor_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/navigation_routes.dart';

class ShopEase extends StatefulWidget {
  @override
  State<ShopEase> createState() => _ShopEaseState();
}

class _ShopEaseState extends State<ShopEase> {
  final appSharedData = injection<AppSharedData>();
  final localPushManager = LocalPushManager.init();

  @override
  void initState() {
    super.initState();
    _fetchPushID();
    if (!AppConstants.isPushServiceInitialized) {
      AppConstants.isPushServiceInitialized = true;
      _configureFirebaseNotification();
    }
  }

  _configureFirebaseNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        localPushManager.showNotification(LocalNotification(
            title: message.notification!.title!,
            body: message.notification!.body!));
      }
    });
  }

  _fetchPushID() async {
    if (!appSharedData.hasPushToken()) {
      if (appSharedData.getPushToken()!.isEmpty) {
        FirebaseMessaging.instance.getToken().then((token) {
          if (token != null) {
            log(token ?? '');
            appSharedData.setPushToken(token ?? '');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 854),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: !FlavorConfig.isProduction(),
            title: AppConstants.appName,
            initialRoute: Routes.kSplashView,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
                primaryColor: AppColors.initColors().primaryOrange,
                textTheme: GoogleFonts.poppinsTextTheme(),
                scaffoldBackgroundColor: AppColors.initColors().nonChangeWhite),
          );
        });
  }
}
