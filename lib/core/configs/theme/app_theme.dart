import 'package:campus_mart/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme(
        focusColor: Colors.black,
        hintStyle: TextStyle(fontStyle: FontStyle.normal)),
    drawerTheme: const DrawerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
    brightness: Brightness.light,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white,
    ),
    fontFamily: "Poppins",
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(shape: CircleBorder()),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)))),
  );

  static final darkTheme = ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(color: Colors.white),
      fontFamily: "Poppins",
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(shape: CircleBorder()),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppColors.darkBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))));
}
