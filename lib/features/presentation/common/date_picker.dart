import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dimensions.dart';
import '../../../utils/app_images.dart';

class DatePickerWidget extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final ValueChanged<bool> onSwitchChanged;
  final Function(bool) onFirstPicked; // New callback for first pick
  final bool isYearVisible;
  final Widget? audienceWidget;

  const DatePickerWidget({
    Key? key,
    required this.label,
    this.selectedDate,
    required this.onTap,
    required this.onSwitchChanged,
    required this.isYearVisible,
    this.audienceWidget,
    required this.onFirstPicked, // Add this line
  }) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late bool _isYearVisible;

  @override
  void initState() {
    super.initState();
    _isYearVisible = widget.isYearVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w, bottom: 8.h, right: 6.w,top: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: AppDimensions.kFontSize12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.initColors().textColor6,
                  ),
                ),
              ),
              widget.audienceWidget??const SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 6.w, right: 6.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Turn off sharing year',
                style: TextStyle(
                  fontSize: AppDimensions.kFontSize10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.initColors().colorGrey,
                ),
              ),
              FlutterSwitch(
                width: 35.0,
                height: 18.0,
                toggleSize: 15.0,
                value: _isYearVisible,
                borderRadius: 25.0,
                padding: 3.0,
                activeColor: AppColors.initColors().primaryBlue,
                inactiveColor: AppColors.initColors().switchGrey,
                onToggle: (value) {
                  if (widget.selectedDate != null) {
                    setState(() {
                      _isYearVisible = value;
                    });
                    widget.onSwitchChanged(value); // Notify parent of change
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: TextEditingController(
              text: widget.selectedDate != null
                  ? _isYearVisible
                      ? DateFormat('MMMM d').format(
                          widget.selectedDate!) // Include year if visible
                      : DateFormat('MMMM d, y').format(
                          widget.selectedDate!) // Correct the formatting
                  : null),
          style: TextStyle(
            fontSize: AppDimensions.kFontSize12,
            fontWeight: FontWeight.w300,
            color: AppColors.initColors().textColor,
          ),
          readOnly: true,
          onTap: widget.onTap,
          decoration: InputDecoration(
            hintText: 'Select Date',
            suffixIcon: SizedBox(
              height: 20,
              width: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  AppImages.icCalendar,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
            filled: false,
            contentPadding:
                EdgeInsets.only(left: 11.w, top: 11.5.h, bottom: 11.5.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors().lightBlue,
                width: 1.0.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors().lightBlue,
                width: 1.0.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors().lightBlue,
                width: 1.0.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.r),
              ),
              borderSide: BorderSide(
                color: AppColors.initColors().colorError,
                width: 1.0.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
