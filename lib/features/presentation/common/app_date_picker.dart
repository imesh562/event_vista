import 'package:eventvista/utils/app_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class AppDatePicker extends StatefulWidget {
  final String? hint;
  final String? helpText;
  String? Function(String?)? validator;
  final bool? isEnable;
  final bool? isRequired;
  final bool? showIcon;
  final bool? showClear;
  final Function()? onClear;
  final String? label;
  final String? titleImage;
  final String? format;
  final DateTime? initialValue;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final Function(DateTime?)? onSelect;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final bool isFormField;
  final Color? iconColor;
  final Color? bgColor;

  AppDatePicker({
    this.hint,
    this.helpText,
    this.label,
    this.titleImage,
    this.format,
    this.isRequired = false,
    this.validator,
    this.onSelect,
    this.initialValue,
    this.isEnable = true,
    this.showIcon = true,
    this.showClear = false,
    this.lastDate,
    this.firstDate,
    this.fieldKey,
    this.isFormField = false,
    this.iconColor,
    this.bgColor,
    this.onClear,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  TextEditingController? _controller;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller = TextEditingController(
          text: DateFormat(widget.format != null
                  ? getFormat(widget.format!)
                  : 'dd/MM/yyyy')
              .format(widget.initialValue!));
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
                  _selectDate(context);
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
                            AppImages.icCalendar3,
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
                          selectedDate = null;
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime tempPickedDate = selectedDate != null
        ? selectedDate!
        : widget.initialValue ?? widget.firstDate ?? DateTime.now();

    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), // Rounded top-left corner
          topRight: Radius.circular(20.0), // Rounded top-right corner
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext builder) {
        return Container(
          height: 300, // Fixed height for CupertinoDatePicker
          color: Colors.white,
          child: Column(
            children: [
              // Action Bar: Cancel and Done Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(null); // Return null on Cancel
                    },
                  ),
                  CupertinoButton(
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(tempPickedDate); // Return selected date
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempPickedDate,
                  minimumDate:
                      widget.initialValue != null && widget.firstDate != null
                          ? widget.initialValue!.isBefore(widget.firstDate!)
                              ? widget.initialValue!
                              : widget.firstDate
                          : widget.firstDate ?? DateTime(1),
                  maximumDate: widget.lastDate ??
                      DateTime.now().add(const Duration(days: 365 * 1000)),
                  onDateTimeChanged: (DateTime picked) {
                    tempPickedDate = picked; // Update temporary date
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    // Update the state if a date was selected
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;

        // Update controller with formatted date
        _controller!.text = DateFormat(
          widget.format != null ? getFormat(widget.format!) : 'dd/MM/yyyy',
        ).format(selectedDate!);

        // Trigger onSelect callback if provided
        if (widget.onSelect != null) {
          widget.onSelect!(selectedDate!);
        }
      });
    } else {
      // Handle cancel with null value
      if (selectedDate == null && widget.onSelect != null) {
        widget.onSelect!(null);
      }
    }
  }

  String getFormat(String format) {
    switch (format) {
      case 'DD/MM/YYYY':
        return 'dd/MM/yyyy';
      case 'MM/DD/YYYY':
        return 'MM/dd/yyyy';
      case 'YYYY/DD/MM':
        return 'yyyy/dd/MM';
      case 'YYYY/MM/DD':
        return 'yyyy/MM/dd';
      case 'd MMM, y':
        return 'd MMM, y';
      default:
        return 'dd/MM/yyyy';
    }
  }
}
