import 'package:flutter/material.dart';
import '../models/calculator_mode.dart';
import '../models/calculation_history.dart';
import '../utils/calculator_logic.dart';
import '../services/storage_service.dart';
class CalculatorProvider extends ChangeNotifier
{
  String _expression='';
  String _result='0';
  CalculatorMode _mode=CalculatorMode.basic;
  bool _isRadianMode=false;
  double _memory=0.0;
  bool _isSecondFunction=false;
  int _decimalPrecision=5;
  String get expression=>_expression;
  String get result=>_result;
  CalculatorMode get mode=>_mode;
  bool get isRadianMode=>_isRadianMode;
  bool get isSecondFunction=>_isSecondFunction;
  bool get hasMemory=>_memory!=0.0;
  int get decimalPrecision=>_decimalPrecision;
  CalculatorProvider()
  {
    _init();
  }
  Future<void> _init() async
  {
    _mode=await StorageService.loadMode();
    _memory=await StorageService.loadMemory();
    final settings=await StorageService.loadSettings();
    _decimalPrecision=settings.decimalPrecision;
    _isRadianMode=settings.isRadianMode;
    notifyListeners();
  }
  void setDecimalPrecision(int precision)
  {
    _decimalPrecision=precision;
    notifyListeners();
  }
  void addToExpression(String value)
  {
    if(_mode==CalculatorMode.programmer)
    {
      _expression+=value;
    }
    else
    {
      if(['sin', 'cos', 'tan', 'asin', 'acos', 'atan', 'log', 'log2', 'ln', 'sqrt', 'cbrt'].contains(value))
      {
        _expression+='$value(';
      }
      else if(value=='x²')
      {
        _expression+='^2';
      } else if(value=='x³')
      {
        _expression+='^3';
      }
      else if(value=='x^y')
      {
        _expression+='^';
      }
      else if(value == 'n!')
      {
        _expression+='!';
      }
      else
      {
        _expression+=value;
      }
    }
    notifyListeners();
  }
  void setExpression(String value)
  {
    _expression=value;
    notifyListeners();
  }
  void loadHistoryEntry(String expression,String result)
  {
    _expression=expression;
    _result=result;
    notifyListeners();
  }
  void toggleSign()
  {
    if(_expression.isNotEmpty)
    {
      _expression=_expression.startsWith('-')
          ? _expression.substring(1)
          : '-$_expression';
    }
    else if(_result!='0'&&_result!='Error')
    {
      _expression=_result.startsWith('-')
          ? _result.substring(1)
          : '-$_result';
    }
    notifyListeners();
  }
  void clear()
  {
    _expression='';
    _result='0';
    notifyListeners();
  }
  void delete()
  {
    if(_expression.isEmpty)
      return;
    final fnTokens=['sin(', 'cos(', 'tan(', 'asin(', 'acos(', 'atan(',
      'log(', 'log2(', 'ln(', 'sqrt(', 'cbrt('];
    for(final fn in fnTokens)
    {
      if(_expression.endsWith(fn))
      {
        _expression=_expression.substring(0,_expression.length-fn.length);
        notifyListeners();
        return;
      }
    }
    _expression=_expression.substring(0,_expression.length- 1);
    notifyListeners();
  }
  void calculate()
  {
    if(_expression.isEmpty)
      return;
    final String res=_mode==CalculatorMode.programmer
        ? CalculatorLogic.evaluateProgrammer(_expression)
        : CalculatorLogic.evaluateExpression(
      _expression,
      isRadianMode:_isRadianMode,
      decimalPrecision:_decimalPrecision,
    );
    _result=res;
    notifyListeners();
  }
  void toggleMode(CalculatorMode newMode)
  {
    _mode=newMode;
    StorageService.saveMode(newMode);
    clear();
    notifyListeners();
  }
  void toggleAngleMode()
  {
    _isRadianMode=!_isRadianMode;
    notifyListeners();
  }
  void toggle2nd()
  {
    _isSecondFunction=!_isSecondFunction;
    notifyListeners();
  }
  void memoryClear()
  {
    _memory=0.0;
    StorageService.saveMemory(_memory);
    notifyListeners();
  }
  void memoryAdd()
  {
    try
    {
      _memory+=double.parse(_result);
      StorageService.saveMemory(_memory);
      notifyListeners();
    }
    catch(_){}
  }
  void memorySubtract()
  {
    try
    {
      _memory-=double.parse(_result);
      StorageService.saveMemory(_memory);
      notifyListeners();
    }
    catch(_){}
  }
  void memoryRecall()
  {
    final val=_memory%1==0
        ?_memory.toInt().toString()
        :_memory.toString();
    addToExpression(val);
  }
}
