import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../circle_shimmer.dart';
import '../rectangle_shimmer.dart';

class NetworkShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleShimmer(
                color: AppColors.initColors().networkBorderColor,
                height: 50,
                width: 70,
                borderRadius: 10.r,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RectangleShimmer(
                    color: AppColors.initColors().networkBorderColor,
                    height: 15,
                    width: 200,
                    borderRadius: 8.r,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RectangleShimmer(
                    color: AppColors.initColors().networkBorderColor,
                    height: 10,
                    width: 250,
                    borderRadius: 8.r,
                  ),
                ],
              )
            ],
          ),
        );
      },
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10),
      itemCount: 7,
    );
  }
}
