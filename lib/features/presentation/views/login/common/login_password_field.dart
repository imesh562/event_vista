import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_images.dart';

class LoginPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? icon;
  final String? hint;
  final Function(String)? onTextChanged;
  final TextInputType? inputType;
  final bool? isEnable;
  final bool? isRequired;
  final bool isPreLogin;
  final int? maxLength;
  final String? guideTitle;
  final bool? shouldRedirectToNextField;
  final int? maxLines;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;
  final TextInputFormatter? textInputFormatter;
  final String? Function(String?)? validator;

  LoginPasswordField({
    this.controller,
    this.icon,
    this.hint,
    this.guideTitle,
    this.maxLength = 128,
    this.maxLines = 1,
    this.onTextChanged,
    this.inputType,
    this.focusNode,
    this.onSubmit,
    this.isEnable = true,
    this.shouldRedirectToNextField = true,
    this.isRequired = false,
    this.isPreLogin = false,
    this.textInputFormatter,
    this.validator,
  });

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, bottom: 6.h, right: 6.w),
          child: Row(
            children: [
              Image.asset(
                AppImages.icLock,
                height: 20.h,
              ),
              SizedBox(width: 4.w),
              RichText(
                text: TextSpan(
                  text: (widget.guideTitle != null ? widget.guideTitle! : ''),
                  style: TextStyle(
                    fontSize: AppDimensions.kFontSize14,
                    fontWeight: FontWeight.w500,
                    color: widget.isPreLogin
                        ? AppColors.initColors().textFieldTitleColor
                        : AppColors.initColors().matteBlack,
                  ),
                  children: [
                    TextSpan(
                      text: widget.isRequired! ? ' *' : '',
                      style: TextStyle(
                        fontSize: AppDimensions.kFontSize14,
                        fontWeight: FontWeight.w500,
                        color: widget.isPreLogin
                            ? AppColors.initColors().textFieldTitleColor
                            : AppColors.initColors().matteBlack,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          onChanged: (text) {
            if (widget.onTextChanged != null) {
              widget.onTextChanged!(text);
            }
          },
          onFieldSubmitted: (value) {
            if (widget.onSubmit != null) widget.onSubmit!(value);
          },
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: obscureText,
          textInputAction: widget.shouldRedirectToNextField!
              ? TextInputAction.next
              : TextInputAction.done,
          enabled: widget.isEnable,
          maxLines: widget.maxLines,
          validator: widget.validator,
          textCapitalization: TextCapitalization.none,
          maxLength: widget.maxLength,
          inputFormatters: [
            if (widget.textInputFormatter != null) widget.textInputFormatter!,
          ],
          style: TextStyle(
            fontSize: AppDimensions.kFontSize14,
            fontWeight: FontWeight.w600,
            color: widget.isPreLogin
                ? AppColors.initColors().loginTitleColor
                : AppColors.initColors().darkGrey,
          ),
          keyboardType: widget.inputType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 11.w, top: 11.5.h, bottom: 11.5.h),
            isDense: true,
            counterText: "",
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? AppColors.initColors().checkBoxBorder
                    : AppColors.initColors().darkStrokeGrey,
                width: 0.75.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? AppColors.initColors().checkBoxBorder
                    : AppColors.initColors().darkStrokeGrey,
                width: 0.75.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? AppColors.initColors().checkBoxBorder
                    : AppColors.initColors().darkStrokeGrey,
                width: 0.75.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: widget.isPreLogin
                    ? AppColors.initColors().checkBoxBorder
                    : AppColors.initColors().darkStrokeGrey,
                width: 0.75.w,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors().errorRed,
                width: 0.75.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors().errorRed,
                width: 0.75.w,
              ),
            ),
            errorMaxLines: 2,
            errorStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: AppDimensions.kFontSize10,
              fontWeight: FontWeight.w400,
              color: AppColors.initColors().errorRed,
            ),
            prefixIcon: widget.icon,
            prefixIconConstraints: BoxConstraints(minWidth: 55.w),
            suffixIconConstraints: BoxConstraints(minHeight: 20.h),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 11.w),
              child: InkResponse(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Image.asset(
                  obscureText ? AppImages.icEyeView : AppImages.icEyeHide,
                  height: obscureText ? 24.h : 20.h,
                  color: widget.isPreLogin
                      ? AppColors.initColors().loginSubTitleColor
                      : AppColors.initColors().lightGrey,
                ),
              ),
            ),
            filled: true,
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: widget.isPreLogin
                    ? AppColors.initColors().loginSubTitleColor
                    : AppColors.initColors().lightGrey,
                fontSize: AppDimensions.kFontSize12,
                fontWeight: FontWeight.w400),
            fillColor: widget.isPreLogin
                ? AppColors.initColors().nonChangeWhite
                : AppColors.initColors().textFieldFill,
          ),
        ),
      ],
    );
  }
}
