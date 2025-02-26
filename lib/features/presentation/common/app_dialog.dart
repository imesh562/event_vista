import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/enums.dart';
import '../../../error/messages.dart';
import '../../../utils/app_dimensions.dart';
import 'app_button.dart';
import 'app_button_outline.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final bool? isError;
  final Color? descriptionColor;
  final Color? positiveColor;
  final String? subDescription;
  final Color? subDescriptionColor;
  final AlertType? alertType;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositiveCallback;
  final VoidCallback? onNegativeCallback;
  final Widget? dialogContentWidget;

  final bool? isSessionTimeout;

  AppDialog(
      {required this.title,
      this.description,
      this.descriptionColor,
      this.subDescription,
      this.subDescriptionColor,
      this.positiveColor,
      this.alertType,
      this.isError = false,
      this.onPositiveCallback,
      this.onNegativeCallback,
      this.positiveButtonText,
      this.negativeButtonText,
      this.dialogContentWidget,
      this.isSessionTimeout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          description != null
              ? Text(
                  description ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppDimensions.kFontSize18,
                      color: AppColors.initColors().matteBlack),
                )
              : const SizedBox(),
          subDescription != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    subDescription ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppDimensions.kFontSize16,
                        color: AppColors.initColors().matteBlack.withOpacity(.6)),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 32.h,
          ),
          Column(
            children: [
              AppButton(
                buttonText: positiveButtonText ?? "OK",
                textColor: AppColors.initColors().white,
                buttonColor: title == ErrorMessages.TITLE_QUESTION
                    ? AppColors.initColors().errorRed
                    : positiveColor ?? AppColors.initColors().buttonColor,
                onTapButton: () {
                  Navigator.pop(context);
                  if (onPositiveCallback != null) {
                    onPositiveCallback!();
                  }
                },
              ),
              SizedBox(
                height: negativeButtonText != null ? 10.h : 0,
              ),
              negativeButtonText != null
                  ? AppButtonOutline(
                      buttonText: negativeButtonText!,
                      onTapButton: () {
                        Navigator.pop(context);
                        if (onNegativeCallback != null) {
                          onNegativeCallback!();
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}
