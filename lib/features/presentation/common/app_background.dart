import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;

  const AppBackground({
    Key? key,
    required this.child,
    this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: backgroundImage == null ? AppColors.initColors().white : null,
        image: backgroundImage != null
            ? DecorationImage(
          image: AssetImage(backgroundImage!),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: child,
    );
  }
}
