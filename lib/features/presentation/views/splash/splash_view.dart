import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../base_view.dart';

class SplashView extends BaseView {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends BaseViewState<SplashView>
    with TickerProviderStateMixin {
  var bloc = injection<AuthBloc>();
  String? token;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    _loadPackageInfo();
    getFirebaseToken();
    super.initState();

    ///TODO: Remove this on API integration.
    Future.delayed(const Duration(milliseconds: 1250)).then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.kDashboardView, (route) => false);
    });
  }

  getFirebaseToken() async {
    token = await FirebaseMessaging.instance.getToken() ?? '';
    print("this.......... $token");
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.initColors().nonChangeWhite,
        body: BlocProvider<AuthBloc>(
          create: (_) => bloc,
          child: BlocListener<AuthBloc, BaseState<AuthState>>(
            listener: (_, state) async {},
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Hero(
                        tag: 'app_logo',
                        child: Image.asset(
                          AppImages.imgSplash,
                          width: 350.w,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _packageInfo != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'V${_packageInfo!.version}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppDimensions.kFontSize12,
                                  color: AppColors.initColors().dark,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
