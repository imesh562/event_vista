import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/service/dependency_injection.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchPushID();
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
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: !FlavorConfig.isProduction(),
            title: AppConstants.appName,
            initialRoute: Routes.kSplashView,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
                primaryColor: AppColors.initColors().primaryBlue,
                textTheme: GoogleFonts.poppinsTextTheme(),
                scaffoldBackgroundColor: AppColors.initColors().nonChangeWhite),
          );
        });
  }
}
