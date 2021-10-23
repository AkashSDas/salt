import 'package:flutter/material.dart';

class DesignSystem {
  /// Colors
  static const white = Colors.white;
  static const dodgerBlue = Color(0xFF1FA1FF);
  static const alabaster = Color(0xFFF7F7F7);
  static const tundora = Color(0xFF4B4B4B);
  static const mineShaft = Color(0xFF373737);
  static const ebonyClay = Color(0xFF2D3346);
  static const boulder = Color(0xFF7D7D7D);
  static const radicalRed = Color(0xFFFF3F56);
  static const greenYellow = Color(0xFFB6FF3F);
  static const gallery = Color(0xFFEFEFEF);

  /// Font Family
  static const fontHead = 'Sofia Pro';
  static const fontBody = 'Sofia Pro';

  /// Font Styles

  /// Heading
  static TextStyle headingTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: fontHead,
      color: ebonyClay,
      fontWeight: FontWeight.w700,
    );
  }

  /// Regular text
  static TextStyle regularTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: fontBody,
      color: mineShaft,
      fontWeight: FontWeight.w400,
      height: 1.4, // 140%
    );
  }

  /// Headings
  static final heading1 = headingTextStyle(34);
  static final heading2 = headingTextStyle(32);
  static final heading3 = headingTextStyle(28);
  static final heading4 = headingTextStyle(24);

  /// Regular
  static const bodyIntro = TextStyle(
    fontSize: 20,
    fontFamily: fontBody,
    color: mineShaft,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static final bodyMain = regularTextStyle(17);
  static final caption = regularTextStyle(15);
  static final small = regularTextStyle(13);

  /// App TextTheme
  static final textTheme = TextTheme(
    headline1: heading1,
    headline2: heading2,
    headline3: heading3,
    headline4: heading4,
    bodyText1: bodyIntro,
    bodyText2: bodyMain,
    caption: caption,
    overline: small,
  );

  /// Box Shadow

  static final boxShadow1 = [
    BoxShadow(
      offset: const Offset(0, 41),
      blurRadius: 157,
      color: Colors.black.withOpacity(0.07),
    ),
    BoxShadow(
      offset: const Offset(0, 8.2),
      blurRadius: 25.51,
      color: Colors.black.withOpacity(0.035),
    ),
  ];

  static final boxShadow2 = [
    BoxShadow(
      offset: const Offset(0, 16),
      blurRadius: 32,
      color: const Color(0xFF767676).withOpacity(0.15),
    ),
    BoxShadow(
      offset: const Offset(0, -8),
      blurRadius: 16,
      color: const Color(0xFF767676).withOpacity(0.05),
    ),
  ];

  static final boxShadow3 = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 6,
      color: Colors.black.withOpacity(0.25),
    ),
  ];

  static final boxShadow4 = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 4,
      color: Colors.black.withOpacity(0.05),
    ),
  ];

  static final boxShadow5 = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 8,
      color: Colors.black.withOpacity(0.15),
    ),
  ];

  static final boxShadow6 = [
    BoxShadow(
      offset: const Offset(0, 8),
      blurRadius: 16,
      color: const Color(0xFF767676).withOpacity(0.25),
    ),
  ];

  /// ThemeData
  static final theme = ThemeData(
    primaryColor: white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: white,
      secondary: dodgerBlue,
      error: radicalRed,
      background: white,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: boulder),
      backgroundColor: white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: dodgerBlue,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      elevation: 0,
      unselectedIconTheme: const IconThemeData(color: tundora),
      selectedIconTheme: const IconThemeData(color: dodgerBlue),
      unselectedItemColor: tundora,
      selectedItemColor: dodgerBlue,
      selectedLabelStyle: caption.copyWith(color: dodgerBlue),
      unselectedLabelStyle: caption,
    ),
    iconTheme: const IconThemeData(color: tundora),
  );
}
