import 'package:eventvista/features/data/datasources/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_images.dart';

class BottomNavBar extends StatefulWidget {
  int selectedTab;
  final AppSharedData appSharedData;
  final Function(int) callback;
  BottomNavBar({
    required this.callback,
    required this.selectedTab,
    required this.appSharedData,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.initColors().newWhite,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.callback(1);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          widget.selectedTab == 1
                              ? AppImages.icHomeSelected
                              : AppImages.icHome,
                          height: 35.h,
                          color: AppColors.initColors().newBlack2,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize8,
                            fontWeight: FontWeight.w500,
                            color: AppColors.initColors().newBlack2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.callback(2);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          widget.selectedTab == 2
                              ? AppImages.icNotificationsSelected
                              : AppImages.icNotifications,
                          height: 35.h,
                          color: AppColors.initColors().newBlack2,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize8,
                            fontWeight: FontWeight.w500,
                            color: AppColors.initColors().newBlack2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.callback(3);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          widget.selectedTab == 4
                              ? AppImages.icProfileSelected
                              : AppImages.icProfile,
                          height: 35.h,
                          color: AppColors.initColors().newBlack2,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize8,
                            fontWeight: FontWeight.w500,
                            color: AppColors.initColors().newBlack2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
