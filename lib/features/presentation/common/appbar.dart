import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eventvista/utils/app_dimensions.dart';

import '../../../utils/app_colors.dart';

class EventVistaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isGoBackVisible;
  final bool isPreLogin;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool? showDivider;
  final bool? showCreateButton;
  final bool? disableCreateButton;
  final VoidCallback? onCreatePressed;

  EventVistaAppBar({
    this.title = '',
    this.actions,
    this.isGoBackVisible = true,
    this.isPreLogin = false,
    this.showDivider = false,
    this.onBackPressed,
    this.showCreateButton = false,
    this.onCreatePressed,
    this.disableCreateButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.initColors().newWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: showDivider!
          ? PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Container(
                color: AppColors.initColors().dividerColor,
                height: 1.0,
              ),
            )
          : null,
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.12.h),
              isGoBackVisible
                  ? InkResponse(
                      onTap: onBackPressed ??
                          () {
                            Navigator.pop(context);
                          },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: isPreLogin
                              ? AppColors.initColors().nonChangeBlack
                              : AppColors.initColors().newBlack,
                          size: 24.h,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: Padding(
                  padding: actions != null
                      ? EdgeInsets.only(left: isGoBackVisible ? 0.w : 20.w)
                      : EdgeInsets.only(right: isGoBackVisible ? 20.w : 0),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.kFontSize16,
                        color: AppColors.initColors().newBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showCreateButton == true)
            Positioned(
              right: 0.w,
              child: InkWell(
                onTap: disableCreateButton != true ? onCreatePressed : null,
                child: Opacity(
                  opacity: disableCreateButton != true ? 1 : 0.5,
                  child: Container(
                    height: 30.12.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 19.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.initColors().primaryBlue,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Center(
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.initColors().white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
