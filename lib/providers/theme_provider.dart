import 'package:flutter/material.dart';
import '../models/calculator_settings.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
class ThemeProvider extends ChangeNotifier
{
  CalculatorSettings _settings=const CalculatorSettings();
  ThemeMode get themeMode
  {
    switch(_settings.themeModeSetting)
    {
      case 'dark':return ThemeMode.dark;
      case 'system':return ThemeMode.system;
      default:return ThemeMode.light;
    }
  }
  bool get isDarkMode=>_settings.themeModeSetting=='dark';
  CalculatorSettings get settings=>_settings;
  ThemeProvider()
  {
    _load();
  }
  Future<void> _load() async
  {
    _settings=await StorageService.loadSettings();
    notifyListeners();
  }
  Future<void> setThemeMode(String mode) async
  {
    _settings=_settings.copyWith(themeModeSetting:mode);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }
  Future<void> updateSettings(CalculatorSettings updated) async
  {
    _settings=updated;
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }
  ThemeData get lightTheme=>ThemeData(
    useMaterial3:true,
    brightness:Brightness.light,
    primaryColor:AppColors.lightPrimary,
    scaffoldBackgroundColor:AppColors.lightPrimary,
    colorScheme:const ColorScheme.light(
      primary:AppColors.lightAccent,
      secondary:AppColors.lightSecondary,
      surface:AppColors.lightSecondary,
    ),
    textTheme:const TextTheme(
      bodyMedium:TextStyle(color:AppColors.textDark),
    ),
    iconTheme:const IconThemeData(color: AppColors.textDark),
    appBarTheme:const AppBarTheme(
      backgroundColor:AppColors.lightPrimary,
      foregroundColor:AppColors.textDark,
      iconTheme:IconThemeData(color:AppColors.textDark),
    ),
  );
  ThemeData get darkTheme=>ThemeData(
    useMaterial3:true,
    brightness:Brightness.dark,
    primaryColor:AppColors.darkPrimary,
    scaffoldBackgroundColor:AppColors.darkPrimary,
    colorScheme:const ColorScheme.dark(
      primary:AppColors.darkAccent,
      secondary:AppColors.darkSecondary,
      surface:AppColors.darkSecondary,
    ),
    textTheme:const TextTheme(
      bodyMedium:TextStyle(color:AppColors.textWhite),
    ),
    iconTheme:const IconThemeData(color:AppColors.textWhite),
    appBarTheme:const AppBarTheme(
      backgroundColor:AppColors.darkPrimary,
      foregroundColor:AppColors.textWhite,
      iconTheme: IconThemeData(color: AppColors.textWhite),
    ),
  );
}