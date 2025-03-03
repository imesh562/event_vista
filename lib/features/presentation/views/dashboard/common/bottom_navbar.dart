import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_images.dart';

class BottomNavBar extends StatefulWidget {
  int selectedTab;
  final Function(int) callback;
  BottomNavBar({required this.callback, required this.selectedTab});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83.h,
      decoration: BoxDecoration(
        color: AppColors.initColors().blackTextColor1,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    widget.callback(1);
                    setState(() {
                      widget.selectedTab = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.icHome,
                        height: 30.h,
                        color: widget.selectedTab != 1
                            ? null
                            : AppColors.initColors().nonChangeWhite,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.initColors().nonChangeWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.callback(2);
                    setState(() {
                      widget.selectedTab = 2;
                    });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.icProfile,
                        height: 30.h,
                        color: widget.selectedTab != 2
                            ? null
                            : AppColors.initColors().nonChangeWhite,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.initColors().nonChangeWhite,
                        ),
                      ),
                    ],
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
