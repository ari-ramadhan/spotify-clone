import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xff42C83C);
  static const lightBackground = Color(0xffF2F2F2);
  static const darkBackground = Color(0xff121212);
  static const black = Color(0xff0D0C0C);

  static const medDarkBackground = Color.fromARGB(235, 17, 17, 17);
  static const grey = Color(0xffBEBEBE);
  static const darkGrey = Color(0xff343434);

  static final List<Map<String, Color>> gradientList = [
    {
      'primaryGradient': Colors.orangeAccent.shade400,
      'secondaryGradient': Colors.orangeAccent.shade700
    },
    {
      'primaryGradient': Colors.purpleAccent.shade400,
      'secondaryGradient': Colors.purpleAccent.shade700
    },
    {
      'primaryGradient': Colors.deepOrangeAccent.shade400,
      'secondaryGradient': Colors.deepOrangeAccent.shade700
    },
    {
      'primaryGradient': Colors.redAccent.shade400,
      'secondaryGradient': Colors.redAccent.shade700
    },
  ];
}
