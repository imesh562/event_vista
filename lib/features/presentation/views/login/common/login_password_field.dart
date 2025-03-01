import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_images.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? icon;
  final Function(String)? onTextChanged;
  final TextInputType? inputType;
  final bool? isEnable;
  final int? maxLength;
  final String? guideTitle;
  final int? maxLines;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;
  final TextInputFormatter? textInputFormatter;
  final String? Function(String?)? validator;

  PasswordField({
    this.controller,
    this.hint,
    this.guideTitle,
    this.icon,
    this.maxLength = 128,
    this.maxLines = 1,
    this.onTextChanged,
    this.inputType,
    this.focusNode,
    this.onSubmit,
    this.isEnable = true,
    this.textInputFormatter,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 8.h, right: 16.w),
          child: Text(
            widget.guideTitle ?? '',
            style: TextStyle(
              fontSize: AppDimensions.kFontSize13,
              fontWeight: FontWeight.w500,
              color: AppColors.initColors().textFieldColor,
            ),
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
            fontWeight: FontWeight.w400,
            color: AppColors.initColors().blackTextColor1,
          ),
          keyboardType: widget.inputType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 16.w, top: 14.h, bottom: 14.h),
            isDense: true,
            counterText: "",
            errorMaxLines: 2,
            errorStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: AppDimensions.kFontSize12,
              fontWeight: FontWeight.w400,
              color: AppColors.initColors().colorError,
            ),
            prefixIcon: widget.icon,
            prefixIconConstraints: BoxConstraints(minWidth: 20.w),
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
                  color: AppColors.initColors().blackTextColor1,
                ),
              ),
            ),
            filled: true,
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: AppColors.initColors().hintColor,
                fontSize: AppDimensions.kFontSize14,
                fontWeight: FontWeight.w400),
            fillColor: AppColors.initColors().primaryOrange.withOpacity(0.08),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.initColors().colorError,
                width: 1.h,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.initColors()
                    .textFieldBottomColor
                    .withOpacity(0.4),
                width: 1.h,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.initColors()
                    .textFieldBottomColor
                    .withOpacity(0.4),
                width: 1.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
