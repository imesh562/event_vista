import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../data/models/responses/posts_response.dart';

class PostWidget extends StatelessWidget {
  final PostsResponse post;
  final VoidCallback onTap;

  const PostWidget({
    Key? key,
    required this.post,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title ?? 'No Title',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.kFontSize18,
                            color: AppColors.initColors().blackTextColor1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'User ID: ${post.userId ?? "Unknown"}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: AppDimensions.kFontSize14,
                            color: AppColors.initColors().greyTextColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Post body
              Text(
                post.body ?? 'No content',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimensions.kFontSize16,
                  color: AppColors.initColors().blackTextColor1,
                ),
              ),
              SizedBox(height: 12.h),
              // Post footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Post ID: ${post.id ?? "Unknown"}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppDimensions.kFontSize14,
                      color: AppColors.initColors().greyTextColor1,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(
                      Icons.comment_outlined,
                      color: AppColors.initColors().primaryOrange,
                    ),
                    label: Text(
                      'Show Comments',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.kFontSize14,
                        color: AppColors.initColors().primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
