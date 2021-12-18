import 'package:flutter/material.dart';

class DesignSystem {
  // Colors
  static const primary = Color(0xff151617);
  static const secondary = Color(0xffEB3700);
  static const card = Color(0xff212324);
  static const icon = Color(0xffB8B8B8);
  static const text1 = Color(0xffFAFAFA);
  static const text2 = Color(0xffB9B9B9);
  static const error = Color(0xffDF0606);
  static const success = Color(0xff06DF5D);
  static const purple = Color(0xff6C05F0);
  static const border = Color(0xff242424);
  static const placeholder = Color(0xff484848);
  static const shimmerBaseColor = Color(0xff3a3a3a);
  static const shimmerHighlightColor = Color(0xff3f3f3f);

  // Font Family
  static const fontHead = 'Sofia Pro';
  static const fontBody = 'Sofia Pro';
  static const fontHighlight = 'Cubano';

  // Typography

  static TextStyle headingTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontFamily: fontHead,
        color: text1,
        fontWeight: FontWeight.w600,
      );

  static final heading1 = headingTextStyle(34);
  static final heading2 = headingTextStyle(32);
  static final heading3 = headingTextStyle(28);
  static final heading4 = headingTextStyle(24);

  static TextStyle regularTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontFamily: fontBody,
        color: text2,
        fontWeight: FontWeight.w400,
      );

  static final bodyIntro = regularTextStyle(20).copyWith(
    fontWeight: FontWeight.w500,
  );
  static final bodyMain = regularTextStyle(17).copyWith(height: 1.4);
  static final medium = regularTextStyle(17).copyWith(
    fontWeight: FontWeight.w500,
  );
  static final caption = regularTextStyle(15);
  static final small = regularTextStyle(13);
  static final button = regularTextStyle(17).copyWith(
    fontWeight: FontWeight.w500,
    color: text1,
  );

  static final textTheme = TextTheme(
    headline1: heading1,
    headline2: heading2,
    headline3: heading3,
    headline4: heading4,
    bodyText1: bodyIntro,
    bodyText2: bodyMain,
    subtitle1: medium,
    caption: caption,
    overline: small,
    button: button,
  );

  // App Theme Data

  static final theme = ThemeData(
    primaryColor: primary,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primary,
      secondary: secondary,
      error: error,
    ),
    backgroundColor: primary,
    cardColor: card,
    iconTheme: const IconThemeData(color: icon),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: icon),
      backgroundColor: primary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: secondary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primary,
      elevation: 0,
      unselectedIconTheme: const IconThemeData(color: icon),
      selectedIconTheme: const IconThemeData(color: secondary),
      unselectedItemColor: icon,
      selectedItemColor: secondary,
      selectedLabelStyle: caption.copyWith(color: secondary),
      unselectedLabelStyle: caption,
    ),
    scaffoldBackgroundColor: primary,
  );

  // Space
  static Widget get spaceH20 => const SizedBox(height: 20);
  static Widget get spaceH40 => const SizedBox(height: 40);
}
