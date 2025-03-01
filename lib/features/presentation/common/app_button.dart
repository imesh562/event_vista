import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/enums.dart';
import '../../../utils/app_dimensions.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final Function onTapButton;
  final ButtonType buttonType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? buttonColor;
  final Color textColor;
  final double? fontSize;

  AppButton({
    required this.buttonText,
    required this.onTapButton,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonColor,
    this.textColor = Colors.white,
    this.fontSize,
    this.buttonType = ButtonType.ENABLED,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.r)),
          border: Border.all(
            color: widget.buttonType == ButtonType.ENABLED
                ? widget.buttonColor ?? AppColors.initColors().primaryOrange
                : AppColors.initColors().primaryOrange.withOpacity(.7),
            width: 1,
          ),
          color: widget.buttonType == ButtonType.ENABLED
              ? widget.buttonColor ?? AppColors.initColors().primaryOrange
              : AppColors.initColors().primaryOrange.withOpacity(.7),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.suffixIcon ?? const SizedBox.shrink(),
              widget.suffixIcon != null
                  ? SizedBox(width: 8.w)
                  : const SizedBox.shrink(),
              Flexible(
                child: Text(
                  widget.buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.buttonType == ButtonType.ENABLED
                        ? widget.textColor
                        : widget.textColor.withAlpha(180),
                    fontWeight: FontWeight.w600,
                    fontSize: widget.fontSize ?? AppDimensions.kFontSize14,
                  ),
                ),
              ),
              widget.prefixIcon != null
                  ? SizedBox(width: 8.w)
                  : const SizedBox.shrink(),
              widget.prefixIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      onTap: () {
        if (widget.buttonType == ButtonType.ENABLED) {
          widget.onTapButton();
        }
      },
    );
  }
}
