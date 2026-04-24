import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import '../models/calculator_mode.dart';
import '../models/calculator_settings.dart';
class StorageService
{
  static const _historyKey='calc_history';
  static const _settingsKey='calc_settings';
  static const _modeKey='calc_mode';
  static const _memoryKey='calc_memory';
  static Future<List<CalculationHistory>> loadHistory() async
  {
    try
    {
      final prefs=await SharedPreferences.getInstance();
      final raw=prefs.getString(_historyKey);
      if(raw==null)
        return [];
      final List<dynamic>decoded=jsonDecode(raw);
      return decoded
          .map((e)=>CalculationHistory.fromMap(e as Map<String,dynamic>))
          .toList();
    }
    catch (_)
    {
      return [];
    }
  }
  static Future<void> saveHistory(List<CalculationHistory> history) async
  {
    final prefs=await SharedPreferences.getInstance();
    final encoded=jsonEncode(history.map((e)=>e.toMap()).toList());
    await prefs.setString(_historyKey,encoded);
  }
  static Future<void> clearHistory() async
  {
    final prefs=await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
  static Future<CalculatorSettings> loadSettings() async
  {
    try
    {
      final prefs=await SharedPreferences.getInstance();
      final raw=prefs.getString(_settingsKey);
      if(raw==null) return const CalculatorSettings();
      return CalculatorSettings.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    }
    catch(_)
    {
      return const CalculatorSettings();
    }
  }
  static Future<void> saveSettings(CalculatorSettings settings) async
  {
    final prefs=await SharedPreferences.getInstance();
    final encoded=jsonEncode(settings.toMap());
    await prefs.setString(_settingsKey,encoded);
  }
  static Future<CalculatorMode> loadMode() async
  {
    try
    {
      final prefs=await SharedPreferences.getInstance();
      final raw=prefs.getString(_modeKey);
      if(raw==null)
        return CalculatorMode.basic;
      return CalculatorMode.values.firstWhere((m)=>m.name==raw,
        orElse:()=>CalculatorMode.basic,
      );
    }
    catch(_)
    {
      return CalculatorMode.basic;
    }
  }
  static Future<void> saveMode(CalculatorMode mode) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.name);
  }
  static Future<double> loadMemory() async
  {
    try
    {
      final prefs=await SharedPreferences.getInstance();
      return prefs.getDouble(_memoryKey) ?? 0.0;
    }
    catch(_)
    {
      return 0.0;
    }
  }
  static Future<void> saveMemory(double memory) async
  {
    final prefs=await SharedPreferences.getInstance();
    await prefs.setDouble(_memoryKey, memory);
  }
}