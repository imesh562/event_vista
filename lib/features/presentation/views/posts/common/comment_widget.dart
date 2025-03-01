import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../data/models/responses/comments_response.dart';

class CommentWidget extends StatelessWidget {
  final CommentsResponse comment;

  const CommentWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 16.w,
                backgroundColor:
                    AppColors.initColors().primaryOrange.withOpacity(0.2),
                child: Text(
                  comment.name?.substring(0, 1).toUpperCase() ?? '?',
                  style: TextStyle(
                    color: AppColors.initColors().primaryOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.kFontSize18,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name ?? 'Anonymous',
                      style: TextStyle(
                        color: AppColors.initColors().blackTextColor1,
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.kFontSize16,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      comment.email ?? 'No email',
                      style: TextStyle(
                        color: AppColors.initColors().greyTextColor1,
                        fontWeight: FontWeight.w400,
                        fontSize: AppDimensions.kFontSize13,
                      ),
                    ),
                  ],
                ),
              ),
              // Comment ID
              Text(
                '#${comment.id}',
                style: TextStyle(
                  color: AppColors.initColors().greyTextColor1,
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimensions.kFontSize12,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Comment body
          Text(
            comment.body ?? 'No comment',
            style: TextStyle(
              color: AppColors.initColors().blackTextColor1,
              fontWeight: FontWeight.w400,
              fontSize: AppDimensions.kFontSize14,
            ),
          ),
        ],
      ),
    );
  }
}
