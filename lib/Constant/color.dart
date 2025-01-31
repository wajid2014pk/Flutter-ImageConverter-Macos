import 'package:flutter/material.dart';

class UiColors {
  static Color lightGreyBackground = const Color(0xffD9D9D9);

  static Color blueColor = const Color(0xff326FFF);
  static Color lightblueColor = const Color(0xff1E60F9);
  static Color darkblueColor = const Color(0xff1B4EC5);
  static Color backgroundColor = const Color(0xffF9F9F9);
  static Color textColor = const Color(0xff919395);

  static Color yellowColor = const Color(0xffFDB602);

  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color? buttonColor = Colors.grey[200];
  static Color greyColor = const Color(0xFF828488);

  //-------------new colors---------------------------
  LinearGradient linearGradientBlueColor = const LinearGradient(
    colors: [const Color(0xFF1E60F9), Color(0xFF144BCB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static Color blueColorNew = const Color(0xff144BCB);
  static Color proBannerGreyColor = const Color(0xff454545);
}
