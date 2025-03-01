import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../../core/service/app_messaging.dart';
import '../../../core/service/dependency_injection.dart';
import '../../../core/service/local_push_manager.dart';
import '../../../flavors/flavor_banner.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/device_info.dart';
import '../../../utils/enums.dart';
import '../../data/datasources/shared_preference.dart';
import '../bloc/base_bloc.dart';
import '../bloc/base_event.dart';
import '../bloc/base_state.dart';
import '../common/app_button.dart';
import '../common/app_button_outline.dart';

abstract class BaseView extends StatefulWidget {
  BaseView({Key? key}) : super(key: key);
}

abstract class BaseViewState<Page extends BaseView> extends State<Page> {
  final appSharedData = injection<AppSharedData>();
  var authBloc = injection<AuthBloc>();
  var deviceInfo = injection<DeviceInfo>();
  LocalPushManager? localPushManager;

  Base<BaseEvent, BaseState<dynamic>> getBloc();

  Widget buildView(BuildContext context);

  bool _isProgressShow = false;
  ValueNotifier<bool> hasInternetAtStartUp = ValueNotifier<bool>(true);
  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  bool isLinkLoaded = false;

  @override
  void initState() {
    super.initState();
    hasInternetAtStartUp.addListener(() {
      if (!hasInternetAtStartUp.value) {
        _connectivity = Connectivity();
        _connectivityStream = _connectivity.onConnectivityChanged;
        _connectivityStream.listen((ConnectivityResult result) {
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            ///TODO: Add an Auth API call here for authentication when internet restores.
            hasInternetAtStartUp.value = true;
            hasInternetAtStartUp.dispose();
          }
        });
      } else {
        hasInternetAtStartUp.dispose();
      }
    });

    if (!AppConstants.isPushServiceInitialized) {
      AppConstants.isPushServiceInitialized = true;
      _configureFirebaseNotification();
      localPushManager =
          LocalPushManager(onFetchedNotification: (notification) {
        if (notification.payload != null) {
          try {
            final payload = FCMData.fromJson(jsonDecode(notification.payload!));
            _handleNotifications(payload);
          } catch (e) {}
        }
      });
    }
  }

  _configureFirebaseNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid && message.notification != null) {
        final pushData = FCMData.fromJson(message.data);
        localPushManager!.showNotification(LocalNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            type: pushData.type,
            messageId: message.messageId,
            payload: jsonEncode(message.data)));
      }
    });
  }

  _handleNotifications(FCMData payload) {
    if (appSharedData.hasAuthUser()) {
      switch (payload.type) {
        ///TODO: Add navigation's according to notification type in here.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: BlocProvider<Base>(
        create: (_) => getBloc(),
        child: BlocListener<Base, BaseState>(
          listener: (context, state) {
            if (state is APILoadingState) {
              showProgressBar();
            } else {
              hideProgressBar();
              if (state is APIFailureState) {
                showSnackBar(state.errorResponseModel.responseError ?? '',
                    AlertType.FAIL);
              } else if (state is AuthorizedFailureState) {
                if (state.isSplash) {
                  logOut();
                } else {
                  showAppDialog(
                    context: context,
                    description: state.errorResponseModel.responseError,
                    onPositiveCallback: () {
                      logOut();
                    },
                  );
                }
              } else if (state is ForceUpdateState) {
                showAppUpdateDialog(context: context);
              } else if (state is MaintenanceState) {
                ///TODO: Add the Maintenance mode UI navigation here.
              }
            }
          },
          child: Listener(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: buildView(context),
            ),
          ),
        ),
      ),
    );
  }

  void logOut() {
    clearData();

    ///TODO: Add login screen navigation here.
  }

  void clearData() {
    setState(() {
      if (appSharedData.hasAppToken()) {
        appSharedData.clearAppToken();
      }
      if (appSharedData.hasPushToken()) {
        appSharedData.clearPushToken();
      }
      AppConstants.selectedTheme = ThemeType.LIGHT;
    });
  }

  void showAppDialog({
    required BuildContext context,
    String? title,
    String? description,
    Color? descriptionColor,
    String? positiveButtonText,
    String? negativeButtonText,
    VoidCallback? onPositiveCallback,
    VoidCallback? onNegativeCallback,
    bool? isDismissible,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible ?? true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.all(14.0),
          backgroundColor: AppColors.initColors().white,
          title: Text(
            title ?? '',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppDimensions.kFontSize14,
              color:
                  AppColors.initColors().textFieldTitleColor, // Customize color
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  description ?? '',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppDimensions.kFontSize10,
                    color:
                        AppColors.initColors().textFieldTitleColor, // Customize
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (negativeButtonText != null)
                      AppButtonOutline(
                        onTapButton: onNegativeCallback ??
                            () {
                              Navigator.pop(context);
                            },
                        buttonText: negativeButtonText,
                      ),
                    if (negativeButtonText != null) const SizedBox(width: 10.0),
                    AppButton(
                      onTapButton: onPositiveCallback ??
                          () {
                            Navigator.pop(context);
                          },
                      buttonText: positiveButtonText ?? 'Ok',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showAppUpdateDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
          backgroundColor: AppColors.initColors().white,
          title: Text(
            "Update Required !",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppDimensions.kFontSize16,
              color: AppColors.initColors().updateColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  "Exciting news! We've made improvements to enhance your experience.\nUpdate now to discover the latest features.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppDimensions.kFontSize12,
                    color:
                        AppColors.initColors().textFieldTitleColor, // Customize
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(),
                    Expanded(
                      child: AppButton(
                        onTapButton: () {
                          ///TODO: Add the store redirection data here.
                          StoreRedirect.redirect(
                            androidAppId: '',
                            iOSAppId: '',
                          );
                        },
                        buttonText: "Update Now",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCustomDialog(Widget child) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 31.w),
            decoration: BoxDecoration(
              color: AppColors.initColors().white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.initColors().nonChangeBlack.withOpacity(0.35),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
            child: IntrinsicHeight(child: child),
          );
        });
      },
    );
  }

  showProgressBar() {
    if (!_isProgressShow) {
      _isProgressShow = true;
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          transitionBuilder: (context, a1, a2, widget) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      alignment: FractionalOffset.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Wrap(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.initColors().white,
                            ),
                            child: CupertinoActivityIndicator(
                              color: AppColors.initColors().textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const SizedBox.shrink();
          });
    }
  }

  hideProgressBar() {
    if (_isProgressShow) {
      Navigator.pop(context);
      _isProgressShow = false;
    }
  }

  showSnackBar(String message, AlertType alertType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: AppDimensions.kFontSize14,
            fontWeight: FontWeight.w400,
            color: AppColors.initColors().nonChangeWhite,
          ),
        ),
        backgroundColor: alertType == AlertType.FAIL
            ? AppColors.initColors().errorRed
            : alertType == AlertType.SUCCESS
                ? AppColors.initColors().waitingTimeColor
                : AppColors.initColors().warningColor,
      ),
    );
  }
}
