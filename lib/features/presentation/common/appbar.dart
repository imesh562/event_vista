import 'package:eventvista/utils/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';

class EventVistaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isGoBackVisible;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool? showDivider;

  EventVistaAppBar({
    this.title = '',
    this.actions,
    this.isGoBackVisible = true,
    this.showDivider = false,
    this.onBackPressed,
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
                color: AppColors.initColors().dividerColor2,
                height: 1.h,
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
                          Icons.arrow_back,
                          color: AppColors.initColors().newBlack,
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
                        fontSize: AppDimensions.kFontSize17,
                        color: AppColors.initColors().blackTextColor1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
