import 'package:flutter/material.dart';

class DesignSystem {
  /// Values for padding/margin will be multiple of this `space` value
  static double space = 16;

  /// Colors
  static Color grey0 = Color(0xffFFFFFF);
  static Color grey1 = Color(0xffF7F7F7);
  static Color grey2 = Color(0xffEFEFEF);
  static Color grey3 = Color(0xff7D7D7D);
  static Color grey4 = Color(0xff626262);
  static Color grey5 = Color(0xff31303C);
  static Color orange = Color(0xffFFC21E);

  /// Font Family
  static String fontHead = 'Sofia Pro';
  static String fontBody = 'Sofia Pro';

  /// Font Styles

  static TextStyle headingTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        color: grey5,
        fontFamily: fontHead,
        fontWeight: FontWeight.w700,
      );

  static TextStyle regularBodyTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        color: grey4,
        fontFamily: fontBody,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  static TextStyle mediumBodyTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        color: grey4,
        fontFamily: fontBody,
        fontWeight: FontWeight.w500,
        height: 1.3,
      );

  static TextStyle heading1 = headingTextStyle(34);
  static TextStyle heading2 = headingTextStyle(32);
  static TextStyle heading3 = headingTextStyle(28);
  static TextStyle heading4 = headingTextStyle(24);
  static TextStyle bodyIntroText = mediumBodyTextStyle(20);
  static TextStyle bodyMainText = regularBodyTextStyle(17);
  static TextStyle mediumText = mediumBodyTextStyle(17);
  static TextStyle captionText = regularBodyTextStyle(15);
  static TextStyle smallText = regularBodyTextStyle(13);

  static TextTheme textTheme = TextTheme(
    headline1: heading1,
    headline2: heading2,
    headline3: heading3,
    headline4: heading4,
    bodyText1: bodyIntroText,
    bodyText2: bodyMainText,
    subtitle1: mediumText,
    caption: captionText,
    subtitle2: smallText,
    button: captionText,
  );

  /// Box shadowa

  static List<BoxShadow> subtleBoxShadow = [
    BoxShadow(
      offset: Offset(0, 16),
      blurRadius: 32,
      color: Color(0xff767676).withOpacity(0.15),
    ),
    BoxShadow(
      offset: Offset(0, -8),
      blurRadius: 16,
      color: Color(0xff767676).withOpacity(0.05),
    ),
  ];
}
