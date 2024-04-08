import 'package:flutter/material.dart';

class AppTheme {
  // static const Color primary = Colors.red;
  static const Color white = Colors.white;
  static const Color primary = Color(0xff1275b3);
  static const Color backgroundStart = Color(0xff1275b3);
  static const Color backgroundEnd = Color(0xff003f66);
  static const Color backgroundCenter = Color(0xff075483);
  static Color tileSelected = Colors.grey.shade300;
  static const Color colorEstadoDP = Color(0xff52c41a);
  static const Color backgroundColorEstadoDP = Color(0xfff6ffed);

  static final ThemeData ligthTheme = ThemeData.light().copyWith(
      primaryColor: primary,
      iconTheme: const IconThemeData(color: primary),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
      // AppBar Theme
      appBarTheme: const AppBarTheme(color: primary, elevation: 0),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primary),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: primary,
              fontSize: 12,
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        selectedColor: primary,
        selectedTileColor: tileSelected,
      ));
}
