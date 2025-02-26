import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'enums.dart';

class AppColors {
  AppColors({
    required this.matteBlack,
    required this.textFieldFill,
    required this.white,
    required this.lightGrey,
    required this.darkStrokeGrey,
    required this.hintColor,
    required this.textColor,
    required this.colorError,
    required this.textColor5,
    required this.textColor6,
    required this.lightBlue,
    required this.colorGrey,
    required this.primaryPink,
    required this.primaryBlue,
    required this.nonChangeBlack,
    required this.nonChangeWhite,
    required this.errorRed,
    required this.colorImagePlaceholder,
    required this.waitingTimeColor,
    required this.warningColor,
    required this.buttonColor,
    required this.dividerColor,
    required this.appButtonOutlineGradient1,
    required this.colorTransparent,
    required this.checkBoxBorder,
    required this.textFieldTitleColor,
    required this.loginTitleColor,
    required this.searchHintColor,
    required this.networkBorderColor,
    required this.switchGrey,
    required this.dark,
    required this.searchBackground,
    required this.newWhite,
    required this.newBlack,
    required this.newBlack2,
    required this.updateColor,
  });

  Color textFieldFill;
  Color matteBlack;
  Color searchBackground;
  Color white;
  Color lightGrey;
  Color darkStrokeGrey;
  Color hintColor;
  Color textColor;
  Color colorError;
  Color textColor5;
  Color textColor6;
  Color lightBlue;
  Color colorGrey;
  Color primaryPink;
  Color primaryBlue;
  Color nonChangeBlack;
  Color nonChangeWhite;
  Color errorRed;
  Color colorImagePlaceholder;
  Color waitingTimeColor;
  Color warningColor;
  Color buttonColor;
  Color dividerColor;
  Color appButtonOutlineGradient1;
  Color colorTransparent;
  Color checkBoxBorder;
  Color textFieldTitleColor;
  Color loginTitleColor;
  Color searchHintColor;
  Color networkBorderColor;
  Color switchGrey;
  Color dark;
  Color newWhite;
  Color newBlack;
  Color newBlack2;
  Color updateColor;

  static AppColors initColors() {
    if (AppConstants.selectedTheme == ThemeType.LIGHT) {
      return initializeLightColors();
    } else {
      return initializeDarkColors();
    }
  }

  static AppColors initializeLightColors() {
    return AppColors(
      ///Changing Colors
      newWhite: const Color(0xFFFFFFFF),
      newBlack: const Color(0xFF000000),
      newBlack2: const Color(0xFF383838),

      ///Non Changing Colors
      matteBlack: const Color(0xFF333333),
      textFieldFill: const Color(0xFFFFFFFF),
      darkStrokeGrey: const Color(0xFF808080),
      white: const Color(0xFFFFFFFF),
      lightGrey: const Color(0xFFF3F4F6),
      searchBackground: const Color(0xFFF5F5F5),
      textFieldTitleColor: const Color(0xFF2D2D2D),
      hintColor: const Color(0xFF002D4C).withOpacity(.5),
      textColor: const Color(0xFF002D4C),
      colorError: const Color(0xFFC62828),
      textColor5: const Color(0xFF606162),
      textColor6: const Color(0xFF3C3C3C),
      lightBlue: const Color(0xFFB8CDFE),
      colorGrey: const Color(0xFF777777),
      primaryPink: const Color(0xFF8777D8),
      primaryBlue: const Color(0xFF6078F8),
      checkBoxBorder: const Color(0xFFD0D0D0),
      nonChangeBlack: const Color(0xFF363636),
      nonChangeWhite: const Color(0xFFFFFFFF),
      errorRed: const Color(0xFFE34040),
      colorImagePlaceholder: const Color(0xFFD9D9D9),
      waitingTimeColor: const Color(0xFF36AE42),
      warningColor: const Color(0xFFD28020),
      buttonColor: const Color(0xFF6078F8),
      dividerColor: const Color(0xFFECEDF2),
      appButtonOutlineGradient1: const Color(0xFF008AA8),
      colorTransparent: Colors.transparent,
      loginTitleColor: const Color(0xFF525252),
      searchHintColor: const Color(0xFF636363),
      networkBorderColor: const Color(0xFFC5C5C5),
      switchGrey: const Color(0xFFCBCBCB),
      dark: const Color(0xFF000000),
      updateColor: const Color(0xFF992E00),
    );
  }

  static AppColors initializeDarkColors() {
    return AppColors(
      ///Changing Colors
      newWhite: const Color(0xFF333333),
      newBlack: const Color(0xFFFFFFFF),
      newBlack2: const Color(0xFFFFFFFF),

      ///Non Changing Colors
      matteBlack: const Color(0xFF333333),
      textFieldFill: const Color(0xFFFFFFFF),
      darkStrokeGrey: const Color(0xFF808080),
      white: const Color(0xFFFFFFFF),
      lightGrey: const Color(0xFFF3F4F6),
      checkBoxBorder: const Color(0xFFD0D0D0),
      searchBackground: const Color(0xFFF5F5F5),
      textFieldTitleColor: const Color(0xFF2D2D2D),
      hintColor: const Color(0xFF002D4C).withOpacity(.5),
      textColor: const Color(0xFF002D4C),
      colorError: const Color(0xFFC62828),
      textColor5: const Color(0xFF606162),
      textColor6: const Color(0xFF3C3C3C),
      lightBlue: const Color(0xFFB8CDFE),
      colorGrey: const Color(0xFF777777),
      primaryPink: const Color(0xFF8777D8),
      primaryBlue: const Color(0xFF6078F8),
      nonChangeBlack: const Color(0xFF363636),
      nonChangeWhite: const Color(0xFFFFFFFF),
      errorRed: const Color(0xFFE34040),
      colorImagePlaceholder: const Color(0xFFD9D9D9),
      waitingTimeColor: const Color(0xFF36AE42),
      warningColor: const Color(0xFFD28020),
      buttonColor: const Color(0xFF6078F8),
      dividerColor: const Color(0xFFECEDF2),
      appButtonOutlineGradient1: const Color(0xFF008AA8),
      colorTransparent: Colors.transparent,
      loginTitleColor: const Color(0xFF525252),
      searchHintColor: const Color(0xFF636363),
      switchGrey: const Color(0xFFCBCBCB),
      dark: const Color(0xFF000000),
      updateColor: const Color(0xFF992E00),
      networkBorderColor: const Color(0xFFC5C5C5),
    );
  }
}
