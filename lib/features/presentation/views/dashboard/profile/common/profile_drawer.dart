import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_dimensions.dart';
import '../../../../../../utils/app_images.dart';
import '../../../../bloc/auth/auth_bloc.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.userData,
    required this.bloc,
    required PackageInfo? packageInfo,
  }) : _packageInfo = packageInfo;

  final Map<String, dynamic>? userData;
  final AuthBloc bloc;
  final PackageInfo? _packageInfo;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 52.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.w,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.file(
                            userData!['profilePic'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Image.asset(
                                AppImages.icCamera,
                                height: 10.h,
                                width: 10.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData!['firstName'] +
                                  ' ' +
                                  userData!['lastName'],
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                fontSize: AppDimensions.kFontSize16,
                                color: AppColors.initColors().blackTextColor1,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              userData!['email'],
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                fontSize: AppDimensions.kFontSize14,
                                color: AppColors.initColors().greyTextColor1,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Divider(
                  color: AppColors.initColors().dividerColor2,
                  height: 1.h,
                ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: () {
                    bloc.add(SignOutEvent());
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Image.asset(
                        AppImages.icLogout,
                        height: 20.h,
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimensions.kFontSize14,
                          color: AppColors.initColors().logoutColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_packageInfo != null)
            Text(
              'Version ${_packageInfo!.version}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppDimensions.kFontSize14,
                color: AppColors.initColors().greyTextColor1,
              ),
            ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
