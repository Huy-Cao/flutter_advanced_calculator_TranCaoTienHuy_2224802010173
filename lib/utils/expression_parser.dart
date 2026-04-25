import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';
class ExpressionParser
{
  static double evaluate(String input,{bool isRadianMode=false})
  {
    String expr=_preprocess(input,isRadianMode:isRadianMode);
    expr=_autoCloseParentheses(expr);
    expr=_stripTrailingOperator(expr);
    final Parser p=Parser();
    final Expression exp=p.parse(expr);
    final ContextModel cm=ContextModel();
    final double result=exp.evaluate(EvaluationType.REAL,cm);
    if(result.isNaN||result.isInfinite)
      throw FormatException('Result is $result');
    return result;
  }
  static String _preprocess(String input,{required bool isRadianMode})
  {
    String s=input;
    s=s.replaceAll('×','*');
    s=s.replaceAll('÷','/');
    s=s.replaceAll('%','/100');
    s=s.replaceAll('x²','^2');
    s=s.replaceAll('x³','^3');
    s=_protectScientificNotation(s);
    s=s.replaceAllMapped(RegExp(r'(\d)(π)'),(m)=>'${m[1]}*${m[2]}');
    s=s.replaceAllMapped(RegExp(r'(\d)(e)(?![0-9+\-_])'),(m)=>'${m[1]}*${m[2]}');
    s=s.replaceAllMapped(RegExp(r'\)(π|e(?![0-9+\-_]))'),(m)=>')*${m[1]}');
    s=s.replaceAll('π',math.pi.toString());
    s=s.replaceAllMapped(
      RegExp(r'(?<![a-zA-Z0-9_])e(?![a-zA-Z0-9+\-_])'),
          (_)=>math.e.toString(),
    );
    s=_expandCbrt(s);
    s=s.replaceAll('√(','sqrt(');
    s=s.replaceAll('√','sqrt(');
    s=_expandFactorial(s);
    if(!isRadianMode)
    {
      for(final fn in ['asin','acos','atan'])
        s=_expandInverseTrigDeg(s,fn);
      for(final fn in ['sin','cos','tan'])
        s=_expandForwardTrigDeg(s,fn);
    }
    else
    {
      s=s.replaceAll('asin(','arcsin(');
      s=s.replaceAll('acos(','arccos(');
      s=s.replaceAll('atan(','arctan(');
    }
    s=s.replaceAll('ln(','__LN__(');
    s=_expandLog2(s);
    s=_expandLog10(s);
    s=s.replaceAll('__LN__(','ln(');
    s=_implicitMultiply(s);
    s=_restoreScientificNotation(s);
    return s;
  }
  static String _protectScientificNotation(String s)
  {
    return s.replaceAllMapped(
      RegExp(r'(\d[\d.]*)([eE])([+\-]?\d+)'),
          (m)=>'${m[1]}__SCI__${m[3]}',
    );
  }
  static String _restoreScientificNotation(String s)
  {
    return s.replaceAll('__SCI__','e');
  }
  static String _expandInverseTrigDeg(String s,String fn)
  {
    final arcFn=fn.replaceFirst('a','arc');
    final result=StringBuffer();
    int i=0;
    final tag='$fn(';
    while(i<s.length)
    {
      if(i+tag.length<=s.length&&s.substring(i,i+tag.length)==tag)
      {
        i+=tag.length;
        int depth=1;
        final argStart=i;
        while(i<s.length&&depth>0)
        {
          if(s[i]=='(') depth++;
          else if(s[i]==')') depth--;
          if(depth>0) i++;
        }
        final arg=s.substring(argStart,i);
        i++;
        result.write('($arcFn($arg)*(180/${math.pi}))');
      }
      else
      {
        result.write(s[i]);
        i++;
      }
    }
    return result.toString();
  }
  static String _expandForwardTrigDeg(String s,String fn)
  {
    final result=StringBuffer();
    int i=0;
    final tag='$fn(';
    while(i<s.length)
    {
      final isInsideArc=i>=3&&s.substring(i-3,i)=='arc';
      if(!isInsideArc&&i+tag.length<=s.length&&s.substring(i,i+tag.length)==tag)
      {
        i+=tag.length;
        int depth=1;
        final argStart=i;
        while(i<s.length&&depth>0)
        {
          if(s[i]=='(') depth++;
          else if(s[i]==')') depth--;
          if(depth>0) i++;
        }
        final arg=s.substring(argStart,i);
        i++;
        result.write('$fn((${math.pi}/180)*($arg))');
      }
      else
      {
        result.write(s[i]);
        i++;
      }
    }
    return result.toString();
  }
  static String _expandLog10(String s)
  {
    final result=StringBuffer();
    int i=0;
    while(i<s.length)
    {
      if(i+4<=s.length&&s.substring(i,i+4)=='log('&&!(i>=1&&s[i-1].contains(RegExp(r'[0-9]'))))
      {
        i+=4;
        int depth=1;
        final argStart=i;
        while(i<s.length&&depth>0)
        {
          if(s[i]=='(') depth++;
          else if(s[i]==')') depth--;
          if(depth>0) i++;
        }
        final arg=s.substring(argStart,i);
        i++;
        result.write('(ln($arg)/ln(10))');
      }
      else
      {
        result.write(s[i]);
        i++;
      }
    }
    return result.toString();
  }
  static String _expandLog2(String s)
  {
    final result=StringBuffer();
    int i=0;
    while(i<s.length)
    {
      if(i+5<=s.length&&s.substring(i,i+5)=='log2(')
      {
        i+=5;
        int depth=1;
        final argStart=i;
        while(i<s.length&&depth>0)
        {
          if(s[i]=='(') depth++;
          else if(s[i]==')') depth--;
          if(depth>0) i++;
        }
        final arg=s.substring(argStart,i);
        i++;
        result.write('(ln($arg)/ln(2))');
      }
      else
      {
        result.write(s[i]);
        i++;
      }
    }
    return result.toString();
  }
  static String _expandCbrt(String s)
  {
    s=s.replaceAll('∛(','cbrt(');
    s=s.replaceAll('∛','cbrt(');
    final result=StringBuffer();
    int i=0;
    while(i<s.length)
    {
      if(i+5<=s.length&&s.substring(i,i+5)=='cbrt(')
      {
        i+=5;
        int depth=1;
        final argStart=i;
        while(i<s.length&&depth>0)
        {
          if(s[i]=='(') depth++;
          else if(s[i]==')') depth--;
          if(depth>0) i++;
        }
        final arg=s.substring(argStart,i);
        i++;
        final trimmed=arg.trim();
        if(trimmed.startsWith('-'))
        {
          final inner=trimmed.substring(1).trim();
          result.write('-(($inner)^(1/3))');
        }
        else
        {
          result.write('(($arg)^(1/3))');
        }
      }
      else
      {
        result.write(s[i]);
        i++;
      }
    }
    return result.toString();
  }
  static String _expandFactorial(String s)
  {
    s=s.replaceAllMapped(RegExp(r'(\d+)!'),(m)
    {
      final n=int.tryParse(m[1]!);
      if(n==null||n<0||n>170) return 'Error';
      return factorial(n.toInt()).toInt().toString();
    });
    return s;
  }
  static String _implicitMultiply(String s)
  {
    s=s.replaceAllMapped(RegExp(r'(\d)([a-zA-Z(])'),(m)=>'${m[1]}*${m[2]}');
    s=s.replaceAllMapped(RegExp(r'\)(\d|\()'),(m)=>')*${m[1]}');
    return s;
  }
  static String _autoCloseParentheses(String s)
  {
    final open='('.allMatches(s).length;
    final close=')'.allMatches(s).length;
    if(open>close) s+=')'*(open-close);
    return s;
  }
  static String _stripTrailingOperator(String s)
  {
    return s.replaceAll(RegExp(r'[+\-*/^.]\s*$'),'');
  }
  static double factorial(int n)
  {
    if(n<0) throw FormatException('Factorial of negative number');
    if(n>170) throw FormatException('Factorial overflow');
    if(n==0) return 1;
    double result=1;
    for(int i=2;i<=n;i++) result*=i;
    return result;
  }
  static double cbrt(double x)=>
      x>=0?math.pow(x,1/3).toDouble():-math.pow(-x,1/3).toDouble();
}