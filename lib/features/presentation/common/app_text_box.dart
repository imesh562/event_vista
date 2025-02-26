import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/app_images.dart';

class AppTextBox extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? helpText;
  final Function(String)? onTextChanged;
  String? Function(String?)? validator;
  final bool? isEnable;
  final bool? isRequired;
  final int? maxLength;
  final String? label;
  final bool? shouldRedirectToNextField;
  final String? initialValue;
  final FocusNode? focusNode;
  final Function(String)? onSubmit;
  final Function()? onFocusLoss;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final bool isFormField;
  final Color? iconColor;
  final Color? bgColor;
  final Color? borderColor;
  final Color? hintColor;
  final double? boxHeight;
  final String? titleImage;
  final TextInputFormatter? textInputFormatter;
  final TextStyle? labelStyle;

  AppTextBox({
    this.controller,
    this.hint,
    this.helpText,
    this.label,
    this.isRequired = false,
    this.maxLength = 250,
    this.onTextChanged,
    this.focusNode,
    this.validator,
    this.onSubmit,
    this.initialValue,
    this.isEnable = true,
    this.shouldRedirectToNextField = true,
    this.onFocusLoss,
    this.fieldKey,
    this.isFormField = false,
    this.iconColor,
    this.bgColor,
    this.hintColor,
    this.titleImage,
    this.borderColor,
    this.boxHeight,
    this.textInputFormatter,
    this.labelStyle,
  });

  @override
  State<AppTextBox> createState() => _AppTextBoxState();
}

class _AppTextBoxState extends State<AppTextBox> {
  double borderRadius = 5;
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
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        (widget.label != null ? widget.label! : ''),
                        style: widget.labelStyle ??
                            TextStyle(
                              fontSize: AppDimensions.kFontSize12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.initColors().textColor6,
                            ),
                      ),
                    ),
                    Text(
                      widget.isRequired! ? ' *' : '',
                      style: widget.labelStyle ??
                          TextStyle(
                            fontSize: AppDimensions.kFontSize12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.initColors().textColor6,
                          ),
                    ),
                  ],
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
                      color: AppColors.initColors().white,
                      fontSize: AppDimensions.kFontSize12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  child: Icon(
                    Icons.info,
                    color: AppColors.initColors().matteBlack,
                    size: 14.w,
                  ),
                )
            ],
          ),
        ),
        if (widget.isEnable!)
          SizedBox(
            height: widget.isEnable!
                ? widget.boxHeight != null
                    ? widget.boxHeight!
                    : 90.h
                : null,
            child: TextFormField(
              onChanged: (text) {
                if (widget.onTextChanged != null) {
                  widget.onTextChanged!(text);
                }
              },
              validator: widget.validator,
              onFieldSubmitted: (value) {
                if (widget.onSubmit != null) widget.onSubmit!(value);
              },
              focusNode: _focusNode,
              controller: _controller,
              key: widget.fieldKey,
              textInputAction: widget.shouldRedirectToNextField!
                  ? TextInputAction.next
                  : TextInputAction.done,
              enabled: widget.isEnable,
              textCapitalization: TextCapitalization.sentences,
              maxLength: widget.maxLength,
              maxLines: 20,
              style: TextStyle(
                fontSize: AppDimensions.kFontSize12,
                fontWeight: FontWeight.w300,
                color: AppColors.initColors().textColor,
              ),
              keyboardType: TextInputType.text,
              inputFormatters: [
                if (widget.textInputFormatter != null)
                  widget.textInputFormatter!
              ],
              scrollPhysics: const BouncingScrollPhysics(),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 10.w, top: 13.h, bottom: 13.h),
                isDense: true,
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.r),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.initColors().lightBlue,
                    width: 1.0.w, // Adjust width as needed
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.r),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.initColors().lightBlue,
                    width: 1.0.w, // Adjust width as needed
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.r),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.initColors().lightBlue,
                    width: 1.0.w, // Adjust width as needed
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.r),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.initColors().colorError,
                    width: 1.0.w, // Adjust width as needed
                  ),
                ),
                errorMaxLines: 2,
                errorStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: AppDimensions.kFontSize10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.initColors().errorRed,
                ),
                filled: true,
                hintText: widget.hint,
                hintStyle: TextStyle(
                    color: widget.hintColor ??
                        AppColors.initColors().darkStrokeGrey,
                    fontSize: AppDimensions.kFontSize12,
                    fontWeight: FontWeight.w400),
                fillColor: widget.bgColor != null
                    ? widget.bgColor!.withOpacity(0.15)
                    : AppColors.initColors().textFieldFill,
              ),
            ),
          )
        else
          Container(
            constraints: BoxConstraints(
              minHeight: 90.h,
            ),
            width: double.infinity,
            padding: EdgeInsets.only(left: 11.w, top: 11.5.h, bottom: 11.5.h),
            decoration: BoxDecoration(
              color: widget.bgColor != null
                  ? widget.bgColor!.withOpacity(0.15)
                  : AppColors.initColors().textFieldFill,
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              border: Border.all(
                color: AppColors.initColors().lightBlue,
                width: 1.0.w,
              ),
            ),
            child: Text(
              widget.initialValue ?? widget.hint ?? '',
              style: widget.initialValue != null
                  ? TextStyle(
                      fontSize: AppDimensions.kFontSize14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.initColors().matteBlack,
                    )
                  : TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: widget.hintColor ??
                          AppColors.initColors().darkStrokeGrey,
                      fontSize: AppDimensions.kFontSize12,
                      fontWeight: FontWeight.w400),
            ),
          )
      ],
    );
  }
}
