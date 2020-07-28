import 'package:flutter/material.dart';

class UniversalVariables {
  static final Color redColor = Color(0xffC75647);
  static final Color blackColor = Color(0xff070707);
  static final Color greyColor = Colors.grey;
  static final Color userCircleBackground = Color(0xff3C838A);
  static final Color onlineDotColor = Color(0xff78B755);
  static final Color lightBlueColor = Color(0xff125CA6);
  static final Color separatorColor = Color(0xff111111);

  static final Color gradientColorStart = Colors.purple;
  static final Color gradientColorEnd = Colors.deepPurple;

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);

  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
