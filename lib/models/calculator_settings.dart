class CalculatorSettings
{
  final String themeModeSetting;
  final int decimalPrecision;
  final bool isRadianMode;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize;
  bool get isDarkMode=>themeModeSetting=='dark';
  const CalculatorSettings({
    this.themeModeSetting='dark',
    this.decimalPrecision=5,
    this.isRadianMode=false,
    this.hapticFeedback=true,
    this.soundEffects=false,
    this.historySize=50,
  });
  CalculatorSettings copyWith({
    String? themeModeSetting,
    int? decimalPrecision,
    bool? isRadianMode,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
  })
  {
    return CalculatorSettings(
      themeModeSetting:themeModeSetting ?? this.themeModeSetting,
      decimalPrecision:decimalPrecision ?? this.decimalPrecision,
      isRadianMode:isRadianMode ?? this.isRadianMode,
      hapticFeedback:hapticFeedback ?? this.hapticFeedback,
      soundEffects:soundEffects ?? this.soundEffects,
      historySize:historySize ?? this.historySize,
    );
  }
  Map<String,dynamic>toMap()=>
  {
    'themeModeSetting':themeModeSetting,
    'decimalPrecision':decimalPrecision,
    'isRadianMode':isRadianMode,
    'hapticFeedback':hapticFeedback,
    'soundEffects':soundEffects,
    'historySize':historySize,
  };
  factory CalculatorSettings.fromMap(Map<String,dynamic>map)
  {
    String themeSetting=map['themeModeSetting'] as String? ?? '';
    if(themeSetting.isEmpty)
    {
      final oldDark=map['isDarkMode'] as bool? ?? true;
      themeSetting=oldDark ? 'dark' : 'light';
    }
    return CalculatorSettings(
      themeModeSetting:themeSetting,
      decimalPrecision:map['decimalPrecision'] as int?  ?? 5,
      isRadianMode:map['isRadianMode'] as bool? ?? false,
      hapticFeedback:map['hapticFeedback'] as bool? ?? true,
      soundEffects:map['soundEffects'] as bool? ?? false,
      historySize:map['historySize'] as int?  ?? 50,
    );
  }
}