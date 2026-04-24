import 'dart:math' as math;
import 'expression_parser.dart';
class CalculatorLogic
{
  static String evaluateExpression(
      String input,
      {
        bool isRadianMode=false,
        int  decimalPrecision=10,
      })
  {
    try
    {
      final double result=ExpressionParser.evaluate(
        input,
        isRadianMode:isRadianMode,
      );
      return _format(result, decimalPrecision);
    }
    catch(e)
    {
      return 'Error';
    }
  }
  static String sin(double x, {bool isRadianMode = false}) =>
      _format(math.sin(isRadianMode ? x : _toRad(x)));
  static String cos(double x, {bool isRadianMode = false}) =>
      _format(math.cos(isRadianMode ? x : _toRad(x)));
  static String tan(double x, {bool isRadianMode = false}) {
    final v = math.tan(isRadianMode ? x : _toRad(x));
    if (v.isInfinite || v.isNaN) return 'Error';
    return _format(v);
  }
  static String asin(double x, {bool isRadianMode = false}) {
    if(x < -1 || x > 1)
      return 'Error';
    final v=math.asin(x);
    return _format(isRadianMode ? v : _toDeg(v));
  }
  static String acos(double x, {bool isRadianMode = false})
  {
    if(x < -1 || x > 1)
      return 'Error';
    final v=math.acos(x);
    return _format(isRadianMode ? v : _toDeg(v));
  }
  static String atan(double x, {bool isRadianMode = false})
  {
    final v = math.atan(x);
    return _format(isRadianMode ? v : _toDeg(v));
  }
  static String log10(double x)
  {
    if(x<=0) return 'Error';
    return _format(math.log(x) / math.ln10);
  }
  static String log2(double x)
  {
    if(x <= 0) return 'Error';
    return _format(math.log(x) / math.log2e);
  }

  static String ln(double x)
  {
    if(x<=0)
      return 'Error';
    return _format(math.log(x));
  }
  static String sqrt(double x)
  {
    if(x<0)
      return 'Error';
    return _format(math.sqrt(x));
  }
  static String cbrt(double x)=>
      _format(ExpressionParser.cbrt(x));
  static String factorial(int n)
  {
    try
    {
      return _format(ExpressionParser.factorial(n));
    }
    catch(_)
    {
      return 'Error';
    }
  }
  static String evaluateProgrammer(String input)
  {
    try
    {
      final trimmed=input.trim();
      if(trimmed.toUpperCase().startsWith('NOT '))
      {
        final operand=trimmed.substring(4).trim();
        final val=_parseHex(operand);
        return (~val & 0xFFFFFFFF).toRadixString(16).toUpperCase();
      }
      final ops = ['AND', 'OR', 'XOR', '<<', '>>', '+', '-', '×', '÷'];
      String? matchedOp;
      for(final op in ops)
      {
        if(input.contains(' $op ')) { matchedOp = op; break; }
      }
      if(matchedOp != null)
      {
        final parts=input.split(' $matchedOp ');
        if (parts.length != 2) return 'Error';
        final a=_parseHex(parts[0].trim());
        final b=_parseHex(parts[1].trim());
        int result;
        switch(matchedOp)
        {
          case 'AND': result = a & b;  break;
          case 'OR':  result = a | b;  break;
          case 'XOR': result = a ^ b;  break;
          case '<<':  result = a << b; break;
          case '>>':  result = a >> b; break;
          case '+':   result = a + b;  break;
          case '-':   result = a - b;  break;
          case '×':   result = a * b;  break;
          case '÷':
            if (b == 0) return 'Error';
            result = a ~/ b;
            break;
          default:    return 'Error';
        }
        return result.toRadixString(16).toUpperCase();
      }
      final val = _parseHex(input.trim());
      return val.toRadixString(16).toUpperCase();
    } catch (_) {
      return 'Error';
    }
  }
  static int _parseHex(String s)
  {
    final clean = s.startsWith('0x') || s.startsWith('0X')
        ? s.substring(2)
        : s;
    return int.parse(clean, radix: 16);
  }
  static double _toRad(double deg) => deg * math.pi / 180.0;
  static double _toDeg(double rad) => rad * 180.0 / math.pi;
  static String _format(double v, [int precision = 10])
  {
    if(v.isNaN || v.isInfinite) return 'Error';
    if(v==v.roundToDouble() && v.abs() < 1e15)
    {
      return v.toInt().toString();
    }
    return v.toStringAsFixed(precision);
  }
}