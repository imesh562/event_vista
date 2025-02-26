import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TapWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool apply;

  /// Ensures a responsive minimum touch target using ScreenUtil
  const TapWrapper({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.apply = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );

    return InkResponse(
      onTap: onTap,
      child: apply
          ? Padding(
        padding: const EdgeInsets.all(8),
        child: widget,
      )
          : widget,
    );
  }
}
