import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/enums.dart';
import '../../../utils/app_dimensions.dart';

class AppButtonOutline extends StatefulWidget {
  final String buttonText;
  final Function onTapButton;
  final double width;
  final double height;
  final bool? isFromDialog;
  final ButtonType buttonType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;

  const AppButtonOutline(
      {required this.buttonText,
      required this.onTapButton,
      this.width = 0,
      this.height = 50,
      this.prefixIcon,
      this.fontSize,
      this.isFromDialog = false,
      this.suffixIcon,
      this.buttonType = ButtonType.ENABLED});

  @override
  State<AppButtonOutline> createState() => _AppButtonOutlineState();
}

class _AppButtonOutlineState extends State<AppButtonOutline> {
  Color _buttonColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: MouseRegion(
        onEnter: (e) {
          setState(() {
            _buttonColor = Colors.transparent;
          });
        },
        onExit: (e) {
          setState(() {
            _buttonColor = AppColors.initColors().buttonColor;
          });
        },
        child: Container(
          padding:EdgeInsets.all(14),
          width: widget.width == 0 ? double.infinity : widget.width,
          // height: widget.height,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(48)),
              color: AppColors.initColors().white,
              border: Border.all(
                  color: widget.buttonType == ButtonType.ENABLED
                      ? AppColors.initColors().buttonColor
                      : AppColors.initColors().white,
                  width: 1)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.prefixIcon ?? const SizedBox.shrink(),
                widget.prefixIcon != null
                    ? const SizedBox(
                        width: 5,
                      )
                    : const SizedBox.shrink(),
                Flexible(
                    child: RichText(
                  text: TextSpan(
                    text: widget.buttonText,
                    style: TextStyle(
                      color: widget.buttonType == ButtonType.ENABLED
                          ? AppColors.initColors().buttonColor
                          : AppColors.initColors().white,
                      fontWeight: widget.isFromDialog!
                          ? FontWeight.w500
                          : FontWeight.w600,
                      fontSize: widget.fontSize ?? (widget.isFromDialog!
                          ? AppDimensions.kFontSize14
                          : AppDimensions.kFontSize16),
                    ),
                  ),
                )),
                widget.suffixIcon != null
                    ? const SizedBox(
                        width: 5,
                      )
                    : const SizedBox.shrink(),
                widget.suffixIcon ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        if (widget.buttonType == ButtonType.ENABLED) {
          if (widget.onTapButton != null) {
            widget.onTapButton();
          }
        }
      },
    );
  }
}
