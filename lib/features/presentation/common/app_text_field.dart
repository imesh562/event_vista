import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eventvista/utils/app_dimensions.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? icon;
  final Widget? action;
  final String? hint;
  final String? helpText;
  final Function(String)? onTextChanged;
  final Function()? onFocusLoss;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool? isEnable;
  final bool? changeColorOnDisable;
  final bool? isRequired;
  final bool? showError;
  final int? maxLength;
  final String? label;
  final bool? obscureText;
  final bool? shouldRedirectToNextField;
  final String? initialValue;
  final int? maxLines;
  final bool? isCurrency;
  final FocusNode? focusNode;
  final FilterType? filterType;
  final Function(String)? onSubmit;
  final TextInputFormatter? textInputFormatter;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final String? titleImage;
  final String? error;
  final bool isPreLogin;
  final bool isFormField;
  final Color? iconColor;
  final Color? bgColor;

  AppTextField({
    this.controller,
    this.icon,
    this.action,
    this.hint,
    this.helpText,
    this.label,
    this.isRequired = false,
    this.showError,
    this.maxLength = 250,
    this.maxLines = 1,
    this.onTextChanged,
    this.onFocusLoss,
    this.inputType,
    this.focusNode,
    this.validator,
    this.onSubmit,
    this.initialValue,
    this.error,
    this.filterType,
    this.isEnable = true,
    this.changeColorOnDisable = false,
    this.obscureText = false,
    this.isCurrency = false,
    this.shouldRedirectToNextField = true,
    this.textInputFormatter,
    this.fieldKey,
    this.titleImage,
    this.isPreLogin = false,
    this.isFormField = false,
    this.iconColor,
    this.bgColor,
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
          padding: EdgeInsets.only(left: 6.w, bottom: 6.h, right: 6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.titleImage != null)
                Row(
                  children: [
                    Image.asset(
                      widget.titleImage!,
                      height: 20.h,
                      opacity: widget.changeColorOnDisable!
                          ? const AlwaysStoppedAnimation(.4)
                          : null,
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              if (widget.titleImage == null && widget.isFormField)
                Row(
                  children: [
                    Image.asset(
                      AppImages.icField,
                      height: 16.h,
                      color: widget.iconColor,
                      opacity: widget.changeColorOnDisable!
                          ? const AlwaysStoppedAnimation(.4)
                          : null,
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: (widget.label != null ? widget.label! : ''),
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize14,
                      fontWeight: FontWeight.w400,
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.initColors()
                                  .textFieldTitleColor
                                  .withOpacity(0.4)
                              : AppColors.initColors().textFieldTitleColor
                          : widget.changeColorOnDisable!
                              ? AppColors.initColors()
                                  .matteBlack
                                  .withOpacity(0.4)
                              : AppColors.initColors().matteBlack,
                    ),
                    children: [
                      TextSpan(
                        text: widget.isRequired! ? ' \u2217' : '',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w400,
                          color: widget.isPreLogin
                              ? widget.changeColorOnDisable!
                                  ? AppColors.initColors()
                                      .textFieldTitleColor
                                      .withOpacity(0.4)
                                  : AppColors.initColors().textFieldTitleColor
                              : widget.changeColorOnDisable!
                                  ? AppColors.initColors()
                                      .matteBlack
                                      .withOpacity(0.4)
                                  : AppColors.initColors().matteBlack,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.helpText != null && widget.helpText! != '')
                SuperTooltip(
                  showBarrier: true,
                  arrowLength: 5,
                  arrowBaseWidth: 5,
                  arrowTipDistance: 5,
                  hasShadow: false,
                  barrierColor: AppColors.initColors().colorTransparent,
                  backgroundColor: AppColors.initColors().matteBlack,
                  content: Text(
                    widget.helpText!,
                    softWrap: true,
                    style: TextStyle(
                      color: widget.isPreLogin
                          ? widget.changeColorOnDisable!
                              ? AppColors.initColors()
                                  .textFieldTitleColor
                                  .withOpacity(0.4)
                              : AppColors.initColors().textFieldTitleColor
                          : widget.changeColorOnDisable!
                              ? AppColors.initColors().white.withOpacity(0.4)
                              : AppColors.initColors().white,
                      fontSize: AppDimensions.kFontSize12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  child: Icon(
                    Icons.info,
                    color: widget.isPreLogin
                        ? widget.changeColorOnDisable!
                            ? AppColors.initColors()
                                .textFieldTitleColor
                                .withOpacity(0.4)
                            : AppColors.initColors().textFieldTitleColor
                        : widget.changeColorOnDisable!
                            ? AppColors.initColors().matteBlack.withOpacity(0.4)
                            : AppColors.initColors().matteBlack,
                    size: 14.w,
                  ),
                )
            ],
          ),
        ),
        TextFormField(
          onChanged: (text) {
            if (widget.isCurrency!) {
              int commaCount = text.split(',').length - 1;
              int dotCount = text.split('.').length - 1;
              setState(() {
                totalCount = commaCount + dotCount;
              });
            }
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
          textInputAction: widget.shouldRedirectToNextField!
              ? TextInputAction.next
              : TextInputAction.done,
          enabled: widget.isEnable,
          maxLines: widget.maxLines,
          textCapitalization: TextCapitalization.sentences,
          maxLength: widget.isCurrency!
              ? widget.maxLength != null
                  ? widget.maxLength! + totalCount
                  : null
              : widget.maxLength,
          inputFormatters: [
            if (widget.isCurrency!)
              CurrencyTextInputFormatter.currency(symbol: ''),
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
            fontWeight: widget.isPreLogin ? FontWeight.w500 : FontWeight.w600,
            color: widget.isPreLogin
                ? widget.changeColorOnDisable!
                    ? AppColors.initColors().loginTitleColor.withOpacity(0.4)
                    : AppColors.initColors().loginTitleColor
                : widget.changeColorOnDisable!
                    ? AppColors.initColors().matteBlack.withOpacity(0.4)
                    : AppColors.initColors().matteBlack,
          ),
          keyboardType: widget.inputType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 11.w, top: 11.5.h, bottom: 11.5.h),
            isDense: true,
            counterText: "",
            errorText: widget.error ?? null,
            errorMaxLines: 2,
            errorStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: AppDimensions.kFontSize12,
              fontWeight: FontWeight.w400,
              color: AppColors.initColors().colorError,
            ),
            prefixIcon: widget.icon,
            prefixIconConstraints: BoxConstraints(minWidth: 55.w),
            suffixIconConstraints:
                BoxConstraints(minWidth: 24.w, maxHeight: 24.h),
            suffixIcon: widget.action,
            filled: false,
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: widget.isPreLogin
                    ? AppColors.initColors().hintColor
                    : AppColors.initColors().hintColor,
                fontSize: AppDimensions.kFontSize16,
                fontWeight: FontWeight.w400),
            fillColor: widget.isPreLogin
                ? AppColors.initColors().nonChangeWhite
                : widget.bgColor != null
                    ? widget.bgColor!.withOpacity(0.15)
                    : AppColors.initColors().textFieldFill,
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors()
                    .colorError, // Red underline when error
                width: 1.0.w, // Adjust width as needed
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.initColors()
                    .lightBlue, // Red underline when error
                width: 1.0.w, // Adjust width as needed
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.initColors()
                    .colorError, // Red underline when error
                width: 1.0.w, // Adjust width as needed
              ),
            ),
          ),
        )
      ],
    );
  }
}
