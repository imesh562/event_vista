import 'package:eventvista/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../utils/app_dimensions.dart';

class PostWidget extends StatefulWidget {
  final String title;
  final String content;
  final String imageUrl;
  const PostWidget({
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: 244.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.initColors().textFieldBottomColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imageUrl,
            height: 130.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 130.h,
                width: double.infinity,
                color: AppColors.initColors().dividerColor2,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: AppColors.initColors().greyTextColor1,
                    size: 32.sp,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.initColors().blackTextColor1,
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimensions.kFontSize16,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: Text(
                      widget.content,
                      maxLines: 3,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.initColors().blackTextColor1,
                        fontWeight: FontWeight.w400,
                        fontSize: AppDimensions.kFontSize14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
