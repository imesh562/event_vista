import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/enums.dart';
import '../../../utils/app_dimensions.dart';

class AppButtonController {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  void setLoading(bool isLoading, {int minimumDurationMs = 300}) {
    if (isLoading) {
      // Start loading immediately
      isLoadingNotifier.value = true;
    } else {
      // Ensure a minimum duration for the loading state
      Future.delayed(Duration(milliseconds: minimumDurationMs), () {
        isLoadingNotifier.value = false;
      });
    }
  }

  bool get isLoading => isLoadingNotifier.value;

  void dispose() {
    isLoadingNotifier.dispose();
  }
}

class AppButton extends StatefulWidget {
  final String buttonText;
  final Function onTapButton;
  final double width;
  final double? height;
  final bool? isFromDialog;
  final ButtonType buttonType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Color? buttonColor;
  final Color textColor;
  final double? fontSize;
  final AppButtonController? controller;

  AppButton({
    required this.buttonText,
    required this.onTapButton,
    this.width = 0,
    this.height,
    this.prefixIcon,
    this.isFromDialog = false,
    this.suffixIcon,
    this.buttonColor,
    this.textColor = Colors.white,
    this.focusNode,
    this.fontSize,
    this.buttonType = ButtonType.ENABLED,
    this.controller,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _widthAnimation;
  Color _buttonColor = AppColors.initColors().appButtonOutlineGradient1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthAnimation = Tween<double>(
      begin: widget.width == 0 ? double.infinity : widget.width,
      end: 50.h, // Shrinks width to height, forming a circular container
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    widget.controller?.isLoadingNotifier.addListener(() {
      if (!mounted) return; // Ensure the widget is still active

      if (widget.controller?.isLoading ?? false) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    widget.controller?.isLoadingNotifier.removeListener(() {
      if (!mounted) return;
      _animationController.reverse();
    });
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: MouseRegion(
        onEnter: (e) {
          setState(() {
            _buttonColor = AppColors.initColors().lightGrey;
          });
        },
        onExit: (e) {
          setState(() {
            _buttonColor = AppColors.initColors().buttonColor;
          });
        },
        child: Focus(
          focusNode: widget.focusNode,
          child: AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return Container(
                width: _widthAnimation.value,
                padding: EdgeInsets.all(8),
                height: widget.height ?? 50.h,
                // Padding around the progress indicator
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(48)),
                  border: Border.all(
                    color: widget.buttonType == ButtonType.ENABLED
                        ? widget.buttonColor ??
                            AppColors.initColors().buttonColor
                        : AppColors.initColors().buttonColor.withOpacity(.7),
                    width: 1,
                  ),
                  color: widget.buttonType == ButtonType.ENABLED
                      ? widget.buttonColor ?? AppColors.initColors().buttonColor
                      : AppColors.initColors().buttonColor.withOpacity(.7),
                ),
                child: Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: widget.controller?.isLoadingNotifier ??
                        ValueNotifier(false),
                    builder: (context, isLoading, child) {
                      return isLoading
                          ? CircularProgressIndicator(
                              color: widget.textColor,
                              strokeWidth: 3,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.suffixIcon ?? const SizedBox.shrink(),
                                widget.suffixIcon != null
                                    ? const SizedBox(width: 5)
                                    : const SizedBox.shrink(),
                                Flexible(
                                  child: Text(
                                    widget.buttonText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: widget.buttonType ==
                                              ButtonType.ENABLED
                                          ? widget.textColor
                                          : widget.textColor.withAlpha(180),
                                      fontWeight: widget.isFromDialog!
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                      fontSize: widget.fontSize ??
                                          (widget.isFromDialog!
                                              ? AppDimensions.kFontSize14
                                              : AppDimensions.kFontSize16),
                                    ),
                                  ),
                                ),
                                widget.prefixIcon != null
                                    ? const SizedBox(width: 5)
                                    : const SizedBox.shrink(),
                                widget.prefixIcon ?? const SizedBox.shrink(),
                              ],
                            );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
      onTap: () {
        if ((widget.controller?.isLoading ?? false) == false &&
            widget.buttonType == ButtonType.ENABLED) {
          widget.onTapButton();
        }
      },
    );
  }
}
