import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eventvista/utils/app_images.dart';

import '../../../../../utils/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.initColors().newWhite,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppImages.icHomeLogo,
              height: 33.76.h,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
