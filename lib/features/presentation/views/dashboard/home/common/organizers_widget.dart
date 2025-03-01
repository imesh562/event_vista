import 'package:eventvista/utils/app_dimensions.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../utils/app_colors.dart';

class OrganizersWidget extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;
  const OrganizersWidget({
    super.key,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  State<OrganizersWidget> createState() => _OrganizersWidgetState();
}

class _OrganizersWidgetState extends State<OrganizersWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: widget.imageUrl.isNotEmpty
                    ? NetworkImage(widget.imageUrl)
                    : null,
                backgroundColor: AppColors.initColors().dividerColor2,
                onBackgroundImageError: widget.imageUrl.isNotEmpty
                    ? (exception, stackTrace) {}
                    : null,
                child: widget.imageUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        color: AppColors.initColors().greyTextColor1,
                      )
                    : null,
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize16,
                      color: AppColors.initColors().blackTextColor1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize14,
                      color: AppColors.initColors().greyTextColor1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            AppImages.icMessage,
            height: 24.h,
          )
        ],
      ),
    );
  }
}
