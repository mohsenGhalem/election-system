import 'package:flutter/material.dart';

class AppTheme {
  //Colors
  static Color primaryColor = Colors.blue;
  static Color lightBlue = Colors.lightBlue;
  static Color selectedBlue = Colors.lightBlue.withOpacity(0.5);

  //TextStyle
  static TextStyle headerStyle =
      const TextStyle(fontWeight: FontWeight.w700, fontSize: 45);
  static TextStyle subHeaderStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
  static TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 25);
  static TextStyle bodyStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 15);
}
