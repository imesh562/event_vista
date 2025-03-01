import 'package:eventvista/utils/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? icon;
  final String? hint;
  final Function(String)? onTextChanged;
  final Function()? onFocusLoss;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool? isEnable;
  final int? maxLength;
  final String? label;
  final bool? obscureText;
  final String? initialValue;
  final int? maxLines;
  final FocusNode? focusNode;
  final FilterType? filterType;
  final Function(String)? onSubmit;
  final TextInputFormatter? textInputFormatter;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final Color? iconColor;

  AppTextField({
    this.controller,
    this.icon,
    this.hint,
    this.label,
    this.maxLength = 250,
    this.maxLines = 1,
    this.onTextChanged,
    this.onFocusLoss,
    this.inputType,
    this.focusNode,
    this.validator,
    this.onSubmit,
    this.initialValue,
    this.filterType,
    this.isEnable = true,
    this.obscureText = false,
    this.textInputFormatter,
    this.fieldKey,
    this.iconColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  int totalCount = 0;
  TextEditingController? _controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      if (widget.initialValue != null) {
        widget.controller!.text = widget.initialValue!;
      }
      _controller = widget.controller;
    } else {
      if (widget.initialValue != null) {
        _controller = TextEditingController(text: widget.initialValue);
      } else {
        _controller = TextEditingController();
      }
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode;
    } else {
      _focusNode = FocusNode();
    }

    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus) {
        if (widget.onFocusLoss != null) {
          widget.onFocusLoss!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 8.h, right: 16.w),
          child: Text(
            widget.label ?? '',
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
          key: widget.fieldKey,
          validator: widget.validator,
          onFieldSubmitted: (value) {
            if (widget.onSubmit != null) widget.onSubmit!(value);
          },
          focusNode: _focusNode,
          controller: _controller,
          obscureText: widget.obscureText!,
          enabled: widget.isEnable,
          maxLines: widget.maxLines,
          textCapitalization: TextCapitalization.sentences,
          maxLength: widget.maxLength,
          inputFormatters: [
            if (widget.textInputFormatter != null) widget.textInputFormatter!,
            if (widget.filterType == FilterType.TYPE1)
              FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9,.]*$'), // Allow digits, dots, and commas.
              ),
            if (widget.filterType == FilterType.TYPE2)
              FilteringTextInputFormatter.allow(
                RegExp(
                    r'[a-zA-Z\s]'), // Allow only, a to z, A to Z or a whitespace.
              ),
            if (widget.filterType == FilterType.TYPE3)
              FilteringTextInputFormatter.allow(
                RegExp(
                    r'[a-zA-Z0-9\s]'), // Allow only, a to z, A to Z, whitespace, and digits.
              ),
            if (widget.filterType == FilterType.TYPE4)
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]')), // Only allow digits
            if (widget.filterType == FilterType.TYPE5)
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}')), // Allow integer or double
            if (widget.filterType == FilterType.TYPE6)
              FilteringTextInputFormatter.allow(
                  RegExp(r'[^\d]')), // Allow anything except numbers
            if (widget.filterType == FilterType.TYPE7)
              FilteringTextInputFormatter.deny(
                RegExp(
                    r'[^\w.@+-]'), // Deny anything NOT in a-z, A-Z, 0-9, ., @, %, +, -, _
              ),
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
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.initColors()
                    .textFieldBottomColor
                    .withOpacity(0.4),
                width: 1.h,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
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
        )
      ],
    );
  }
}
