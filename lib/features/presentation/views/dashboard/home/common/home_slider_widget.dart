import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_dimensions.dart';
import '../../../../../data/models/responses/image_slider_response.dart';

class HomeSliderWidget extends StatefulWidget {
  final List<ImageSliderResponse> images;
  const HomeSliderWidget({super.key, required this.images});

  @override
  State<HomeSliderWidget> createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            currentImageIndex = index;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Image.network(
                widget.images[index].thumbnailUrl ?? '',
                width: double.infinity,
                height: 220.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 220.h,
                    color: AppColors.initColors().dividerColor2,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.initColors().greyTextColor1,
                        size: 40.sp,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.initColors().white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '${currentImageIndex + 1} / ${widget.images.length}',
                    style: TextStyle(
                      color: AppColors.initColors().blackTextColor1,
                      fontWeight: FontWeight.w400,
                      fontSize: AppDimensions.kFontSize12,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
