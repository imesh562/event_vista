import 'package:eventvista/utils/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class AppTimePicker extends StatefulWidget {
  final String? hint;
  final String? helpText;
  String? Function(String?)? validator;
  final bool? showClear;
  final bool? showIcon;
  final Function()? onClear;
  final bool? isEnable;
  final bool? isRequired;
  final String? label;
  final String? format;
  final String? titleImage;
  final DateTime? initialValue;
  final bool? changeColorOnDisable;
  final Function(DateTime?)? onSelect;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final bool isFormField;
  final Color? iconColor;
  final Color? bgColor;

  AppTimePicker({
    this.hint,
    this.helpText,
    this.label,
    this.isRequired = false,
    this.validator,
    this.format,
    this.titleImage,
    this.changeColorOnDisable = false,
    this.onSelect,
    this.initialValue,
    this.isEnable = true,
    this.fieldKey,
    this.isFormField = false,
    this.iconColor,
    this.bgColor,
    this.onClear,
    this.showClear = false,
    this.showIcon = true,
  });

  @override
  State<AppTimePicker> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends State<AppTimePicker> {
  TextEditingController? _controller;
  DateTime? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller =
          TextEditingController(text: formatString(widget.initialValue!));
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4.h, right: 6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.titleImage != null)
                Row(
                  children: [
                    Image.asset(
                      widget.titleImage!,
                      height: 20.h,
                      color: widget.iconColor ??
                          AppColors.initColors().primaryOrange,
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
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: AppDimensions.kFontSize12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.initColors().textColor5,
                        ),
                      ),
                    ),
                    Text(
                      widget.isRequired! ? ' *' : '',
                      style: TextStyle(
                        fontSize: AppDimensions.kFontSize12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.initColors().textColor5,
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
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.isEnable!) {
                  _selectTime(context);
                }
              },
              child: TextFormField(
                validator: widget.validator,
                controller: _controller,
                key: widget.fieldKey,
                enabled: false,
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.initColors().textColor,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 13.w, top: 13.h, bottom: 13.h),
                  isDense: true,
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.7.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.initColors().lightBlue,
                      width: 0.84.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.7.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.initColors().lightBlue,
                      width: 0.84.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.7.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.initColors().lightBlue,
                      width: 0.84.w,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.7.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.initColors().lightBlue,
                      width: 0.84.w,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.7.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.initColors().lightBlue,
                      width: 0.84.w,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.7.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.initColors().lightBlue,
                      width: 0.84.w,
                    ),
                  ),
                  errorMaxLines: 2,
                  errorStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: AppDimensions.kFontSize10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.initColors().errorRed,
                  ),
                  suffixIconConstraints: BoxConstraints(maxHeight: 28.h),
                  suffixIcon: widget.showIcon! &&
                          (widget.showClear == false ||
                              _controller!.text.isEmpty)
                      ? Padding(
                          padding: EdgeInsets.only(right: 11.w),
                          child: Image.asset(
                            AppImages.icTime,
                            width: 25.w,
                          ),
                        )
                      : null,
                  filled: true,
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                      color: AppColors.initColors().darkStrokeGrey,
                      fontSize: AppDimensions.kFontSize12,
                      fontWeight: FontWeight.w300),
                  fillColor: widget.bgColor != null
                      ? widget.bgColor!.withOpacity(0.15)
                      : AppColors.initColors().textFieldFill,
                ),
              ),
            ),
            if (widget.showClear != null &&
                widget.showClear! &&
                _controller!.text.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    height: 47.5.h,
                    width: 30.w,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.clear();
                          selectedTime = null;
                          if (widget.onClear != null) {
                            widget.onClear!();
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 11.w),
                        child: Icon(
                          Icons.close,
                          size: 25.h,
                        ),
                      ),
                    )),
              )
          ],
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    DateTime? picked;
    if (widget.format != null && widget.format == 'hh:mm A') {
      picked = await DatePicker.showTime12hPicker(
        context,
        showTitleActions: true,
        currentTime: selectedTime != null
            ? selectedTime!
            : widget.initialValue != null
                ? widget.initialValue!
                : DateTime.now(),
      );
    } else {
      picked = await DatePicker.showTimePicker(
        context,
        showSecondsColumn: false,
        showTitleActions: true,
        currentTime: selectedTime != null
            ? selectedTime!
            : widget.initialValue != null
                ? widget.initialValue!
                : DateTime.now(),
      );
    }

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked!;
        if (selectedTime != null) {
          _controller!.text = formatString(selectedTime!);
          if (widget.onSelect != null) {
            widget.onSelect!(selectedTime!);
          }
        }
      });
    } else {
      if (selectedTime == null) {
        if (widget.onSelect != null) {
          widget.onSelect!(null);
        }
      }
    }
  }

  String formatString(DateTime time) {
    switch (widget.format) {
      case 'HH:mm':
        return DateFormat('HH:mm').format(time);
      case 'hh:mm A':
        DateFormat outputFormat = DateFormat('h:mm a');
        return outputFormat.format(time);
      default:
        return DateFormat('HH:mm').format(time);
    }
  }
}
