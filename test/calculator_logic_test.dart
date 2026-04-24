// Written to ICPC
// ┌───────────────────────────────────────────────────────────┬──────────┐
// │  Group  │  Topic                                          │  Tests   │
// ├──────────┼─────────────────────────────────────────────────┼──────────┤
// │  A       │  Basic arithmetic                               │  16      │
// │  B       │  Operator precedence (PEMDAS/BODMAS)            │  8       │
// │  C       │  Parentheses & auto-close                       │  8       │
// │  D       │  Trig – degree mode                             │  14      │
// │  E       │  Trig – radian mode                             │  10      │
// │  F       │  Inverse trig (asin / acos / atan)              │  14      │
// │  G       │  Logarithms (log / log2 / ln)                   │  20      │
// │  H       │  Power & roots (^, sqrt, cbrt)                  │  18      │
// │  I       │  Factorial                                       │  14      │
// │  J       │  Constants (π, e) & implicit multiplication      │  10      │
// │  K       │  Decimal precision formatting                   │  10      │
// │  L       │  Programmer – AND / OR / XOR                    │  12      │
// │  M       │  Programmer – arithmetic                        │  10      │
// │  N       │  Programmer – shifts (<< / >>)                  │  10      │
// │  O       │  Programmer – NOT (32-bit)                      │  6       │
// │  P       │  Error / edge cases                             │  16      │
// │  Q       │  CalculationHistory serialisation               │  10      │
// │  R       │  Lab specification vectors (grading rubric)     │  12      │
// │  S       │  ExpressionParser static helpers                │  10      │
// └──────────┴─────────────────────────────────────────────────┴──────────┘
//  Total: ~218 test cases
import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:advancedcalculator_2224802010173_trancaotienhuy/utils/calculator_logic.dart';
import 'package:advancedcalculator_2224802010173_trancaotienhuy/utils/expression_parser.dart';
import 'package:advancedcalculator_2224802010173_trancaotienhuy/models/calculation_history.dart';
String eval(String expr,{bool rad=false,int prec=10})=>
    CalculatorLogic.evaluateExpression(
      expr,
      isRadianMode:rad,
      decimalPrecision:prec,
    );
String prog(String expr)=>CalculatorLogic.evaluateProgrammer(expr);
double asDouble(String expr,{bool rad=false,int prec=10})
{
  final s=eval(expr,rad:rad,prec:prec);
  expect(s,isNot('Error'),
      reason:'Expected numeric result for "$expr" but got Error');
  return double.parse(s);
}
void expectClose(
    String expr,
    double expected,{
      bool rad=false,
      int prec=10,
      double delta=1e-8,
    }){
  final got=asDouble(expr,rad:rad,prec:prec);
  expect(
    got,
    closeTo(expected,delta),
    reason:'"$expr" → $got,expected≈$expected(Δ=$delta)',
  );
}
void expectHex(String expr, String expectedHex)
{
  expect(
    prog(expr),
    expectedHex.toUpperCase(),
    reason:'prog("$expr")should be${expectedHex.toUpperCase()}',
  );
}
// Tests
void main()
{
  group('A – Basic Arithmetic',()
  {
    test('A01 integer addition',()=>expect(eval('2+3'),'5'));
    test('A02 integer subtraction',()=>expect(eval('10-4'),'6'));
    test('A03 integer multiplication',()=>expect(eval('6×7'),'42'));
    test('A04 exact division',()=>expect(eval('15÷3'),'5'));
    test('A05 large addition',()=>expect(eval('999+1'),'1000'));
    test('A06 zero plus zero',()=>expect(eval('0+0'),'0'));
    test('A07 subtract to zero',()=>expect(eval('5-5'),'0'));
    test('A08 multiply by zero',()=>expect(eval('9999×0'),'0'));
    test('A09 multiply by one',()=>expect(eval('42×1'),'42'));
    test('A10 negative result',()=>expect(eval('3-10'),'-7'));
    test('A11 negative operand',()=>expect(eval('-5+3'),'-2'));
    test('A12 double negative',()=>expect(eval('-5+-3'),'-8'));
    test('A13 non-exact division prec=4',()=>expect(eval('1÷3',prec:4),'0.3333'));
    test('A14 chained additions',()=>expect(eval('1+2+3+4+5'),'15'));
    test('A15 large product',()=>expect(eval('1000×1000'),'1000000'));
    test('A16 fractional subtraction',()=>expectClose('1.5-1.5',0.0));
  });
  group('B – Operator Precedence',()
  {
    test('B01 mul before add',()=>expect(eval('2+3×4'),'14'));
    test('B02 div before sub',()=>expect(eval('10-6÷2'),'7'));
    test('B03 mul and div left-to-right',()=>expect(eval('4×3÷2'),'6'));
    test('B04 ^ before mul',()=>expect(eval('2+3^2'),'11'));
    test('B05 long mixed chain',()=>expect(eval('1+2×3-4÷2'),'5'));
    test('B06 unary minus then *',()=>expectClose('-2×3',-6.0));
    test('B07 two products summed',()=>expectClose('2×3+4×5',26.0));
    test('B08 all four operators',()
    {
      expect(eval('12+8×3-20÷4'),'31');
    });
  });
  group('C – Parentheses & Auto-close',()
  {
    test('C01 basic override',()=>expect(eval('(2+3)×4'),'20'));
    test('C02 nested parens',()=>expect(eval('((2+3))×4'),'20'));
    test('C03 auto-close 1 open',()=>expect(eval('(1+2'),'3'));
    test('C04 auto-close nested',()=>expect(eval('((4+5'),'9'));
    test('C05 parens both sides',()=>expect(eval('(2+3)×(4-1)'), '15'));
    test('C06 trivially balanced',()=>expect(eval('(7)'),'7'));
    test('C07 deeply nested',()=>expect(eval('(((3)))'),'3'));
    test('C08 auto-close trig arg',()=>expectClose('sin(30',0.5));
  });
  group('D – Trig: Degree Mode',()
  {
    test('D01 sin(0°)=0',()=>expect(eval('sin(0)'),'0'));
    test('D02 sin(90°)=1',()=>expect(eval('sin(90)'),'1'));
    test('D03 sin(180°)≈0',()=>expectClose('sin(180)',0.0,delta:1e-9));
    test('D04 sin(270°)≈-1',()=>expectClose('sin(270)',-1.0,delta:1e-9));
    test('D05 cos(0°)=1',()=>expect(eval('cos(0)'),'1'));
    test('D06 cos(90°)≈0',()=>expectClose('cos(90)',0.0,delta:1e-9));
    test('D07 cos(180°)=-1',()=>expect(eval('cos(180)'),'-1'));
    test('D08 cos(360°)≈1',()=>expectClose('cos(360)',1.0,delta:1e-9));
    test('D09 tan(0°)=0',()=>expect(eval('tan(0)'),'0'));
    test('D10 tan(45°)≈1',()=>expectClose('tan(45)',1.0,delta:1e-9));
    test('D11 tan(135°)≈-1',()=>expectClose('tan(135)',-1.0,delta:1e-9));
    test('D12 sin(30°)=0.5',()=>expect(eval('sin(30)'),'0.5'));
    test('D13 cos(60°)=0.5',()=>expect(eval('cos(60)'),'0.5'));
    test('D14 sin(45°)=cos(45°)',()
    {
      expect(asDouble('sin(45)'),closeTo(asDouble('cos(45)'),1e-10));
    });
  });
  group('E – Trig: Radian Mode',()
  {
    test('E01 sin(0)=0',()=>expect(eval('sin(0)',rad:true),'0'));
    test('E02 sin(π/2)≈1',()=>expectClose('sin(π÷2)',1.0,rad:true,delta:1e-9));
    test('E03 sin(π)≈0',()=>expectClose('sin(π)',0.0,rad:true,delta:1e-9));
    test('E04 sin(3π/2)≈-1',()=>expectClose('sin(3×π÷2)',-1.0,rad:true,delta:1e-9));
    test('E05 cos(0)=1',()=>expect(eval('cos(0)',rad:true),'1'));
    test('E06 cos(π)=-1',()=>expectClose('cos(π)',-1.0,rad:true,delta:1e-9));
    test('E07 cos(π/2)≈0',()=>expectClose('cos(π÷2)',0.0,rad:true,delta:1e-9));
    test('E08 tan(π/4)≈1',()=>expectClose('tan(π÷4)',1.0,rad:true,delta:1e-9));
    test('E09 Pythagorean identity sin²+cos²=1',()
    {
      expectClose('sin(0.7)^2+cos(0.7)^2',1.0,rad:true,delta:1e-9);
    });
    test('E10 sin negative angle',   () {
      expectClose('sin(-1)',-math.sin(1.0),rad:true,delta:1e-9);
    });
  });
  group('F – Inverse Trig (degree output)',()
  {
    test('F01 asin(0)=0°',()=>expect(eval('asin(0)'),'0'));
    test('F02 asin(1)=90°',()=>expect(eval('asin(1)'),'90'));
    test('F03 asin(-1)=-90°',()=>expect(eval('asin(-1)'),'-90'));
    test('F04 asin(0.5)=30°',()=>expectClose('asin(0.5)',30.0,delta:1e-7));
    test('F05 acos(1)=0°',()=>expect(eval('acos(1)'),'0'));
    test('F06 acos(0)=90°',()=>expectClose('acos(0)',90.0,delta:1e-7));
    test('F07 acos(-1)=180°',()=>expectClose('acos(-1)',180.0,delta:1e-7));
    test('F08 acos(0.5)=60°',()=>expectClose('acos(0.5)', 60.0,delta:1e-7));
    test('F09 atan(0)=0°',()=>expect(eval('atan(0)'),'0'));
    test('F10 atan(1)=45°',()=>expectClose('atan(1)',45.0,delta:1e-7));
    test('F11 atan(-1)=-45°',()=>expectClose('atan(-1)',-45.0,delta:1e-7));
    test('F12 asin(1)=π/2 (rad)',()=>expectClose('asin(1)',math.pi/2,rad:true,delta:1e-9));
    test('F13 acos(-1)=π (rad)',()=>expectClose('acos(-1)',math.pi,rad:true,delta:1e-9));
    test('F14 asin(2)=Error',()=>expect(eval('asin(2)'),'Error'));
    test('F15 acos(-2)=Error',()=>expect(eval('acos(-2)'),'Error'));
  });
  group('G – Logarithms (log₁₀/ log₂/ln)',()
  {
    test('G01 log(1)=0',()=>expect(eval('log(1)'),'0'));
    test('G02 log(10)=1',()=>expect(eval('log(10)'),'1'));
    test('G03 log(100)=2',()=>expect(eval('log(100)'),'2'));
    test('G04 log(1000)=3',()=>expect(eval('log(1000)'),'3'));
    test('G05 log(0.1)=-1',()=>expectClose('log(0.1)',-1.0,delta:1e-9));
    test('G06 log(0)=Error',()=>expect(eval('log(0)'),'Error'));
    test('G07 log(-1)=Error',()=>expect(eval('log(-1)'),'Error'));
    test('G08 ln(1)=0',()=>expect(eval('ln(1)'),'0'));
    test('G09 ln(e)=1',()=>expectClose('ln(e)',1.0,delta:1e-9));
    test('G10 ln(e²)=2',()=>expectClose('ln(e^2)',2.0,delta:1e-9));
    test('G11 ln(0)=Error',()=>expect(eval('ln(0)'),'Error'));
    test('G12 ln(-5)=Error',()=>expect(eval('ln(-5)'),'Error'));
    test('G13 log2(1)=0',()=>expect(eval('log2(1)'),'0'));
    test('G14 log2(2)=1',()=>expect(eval('log2(2)'),'1'));
    test('G15 log2(4)=2',()=>expect(eval('log2(4)'),'2'));
    test('G16 log2(8)=3',()=>expect(eval('log2(8)'),'3'));
    test('G17 log2(1024)=10',()=>expectClose('log2(1024)',10.0,delta:1e-9));
    test('G18 CalculatorLogic.log10(10)=1',()=>expect(CalculatorLogic.log10(10),'1'));
    test('G19 CalculatorLogic.log10(0)=Error',()=>expect(CalculatorLogic.log10(0),'Error'));
    test('G20 CalculatorLogic.ln(1)=0',()=>expect(CalculatorLogic.ln(1),'0'));
    test('G21 CalculatorLogic.log2(8)=3',()=>expect(CalculatorLogic.log2(8),'3'));
  });
  group('H – Power and Root Operations',()
  {
    test('H01 2^10=1024',()=>expect(eval('2^10'),'1024'));
    test('H02 3^3=27',()=>expect(eval('3^3'),'27'));
    test('H03 5^0=1',()=>expect(eval('5^0'),'1'));
    test('H04 2^-1=0.5',()=>expectClose('2^-1',0.5));
    test('H05 (-2)^3=-8',()=>expectClose('(-2)^3',-8.0));
    test('H06 2^0.5=√2',()=>expectClose('2^0.5',math.sqrt2,delta:1e-9));
    test('H07 sqrt(4)=2',()=>expect(eval('sqrt(4)'),'2'));
    test('H08 sqrt(9)=3',()=>expect(eval('sqrt(9)'),'3'));
    test('H09 sqrt(0)=0',()=>expect(eval('sqrt(0)'),'0'));
    test('H10 sqrt(2) ≈ 1.414…',()=>expectClose('sqrt(2)',math.sqrt2,delta:1e-9));
    test('H11 sqrt(-1)=Error',()=>expect(eval('sqrt(-1)'),'Error'));
    test('H12 cbrt(8)=2',()=>expectClose('cbrt(8)',2.0));
    test('H13 cbrt(27)=3',()=>expectClose('cbrt(27)',3.0));
    test('H14 cbrt(-8)=-2',()=>expectClose('cbrt(-8)',-2.0,delta:1e-9));
    test('H15 cbrt(0)=0',()=>expectClose('cbrt(0)',0.0));
    test('H16 cbrt(1000)=10',()=>expectClose('cbrt(1000)',10.0,delta:1e-9));
    test('H17 CalculatorLogic.sqrt(16)=4',()=>expect(CalculatorLogic.sqrt(16),'4'));
    test('H18 CalculatorLogic.sqrt(-4)=Error',()=>expect(CalculatorLogic.sqrt(-4),'Error'));
    test('H19 CalculatorLogic.cbrt(8)',()
    {
      final v=double.parse(CalculatorLogic.cbrt(8));
      expect(v,closeTo(2.0,1e-9));
    });
  });
  group('I – Factorial',()
  {
    test('I01 0!=1',()=>expect(eval('0!'),'1'));
    test('I02 1!=1',()=>expect(eval('1!'),'1'));
    test('I03 2!=2',()=>expect(eval('2!'),'2'));
    test('I04 3!=6',()=>expect(eval('3!'),'6'));
    test('I05 4!=24',()=>expect(eval('4!'),'24'));
    test('I06 5!=120',()=>expect(eval('5!'),'120'));
    test('I07 6!=720',()=>expect(eval('6!'),'720'));
    test('I08 10!=3628800',()=>expect(eval('10!'),'3628800'));
    test('I09 factorial(0)=1',()=>expect(ExpressionParser.factorial(0),1.0));
    test('I10 factorial(5)=120',()=>expect(ExpressionParser.factorial(5),120.0));
    test('I11 factorial(7)=5040',()=>expect(ExpressionParser.factorial(7),5040.0));
    test('I12 factorial(10)=3628800',()=>expect(ExpressionParser.factorial(10),3628800.0));
    test('I13 factorial(-1) throws',()=>expect(()=>ExpressionParser.factorial(-1), throwsFormatException));
    test('I14 factorial(171) throws',()=>expect(()=>ExpressionParser.factorial(171),throwsFormatException));
    test('I15 factorial(170) finite',()
    {
      expect(ExpressionParser.factorial(170).isFinite,isTrue);
    });
    test('I16 factorial in expression: 3!+2!=8',()
    {
      expect(eval('3!+2!'),'8');
    });
  });
  group('J – Constants and Implicit Multiplication',()
  {
    test('J01 π value',()=>expectClose('π',math.pi,delta:1e-9));
    test('J02 e value',()=>expectClose('e',math.e,delta:1e-9));
    test('J03 2π = 2*π',()=>expectClose('2π',2*math.pi,delta:1e-9));
    test('J04 3e = 3*e',()=>expectClose('3e',3*math.e,delta:1e-9));
    test('J05 π^2',()=>expectClose('π^2',math.pi*math.pi,delta:1e-9));
    test('J06 e^1=e',()=>expectClose('e^1',math.e,delta:1e-9));
    test('J07 (2)(3)=6',()=>expect(eval('(2)(3)'),'6'));
    test('J08 2(3+4)=14',()=>expect(eval('2(3+4)'),'14'));
    test('J09 π÷π=1',()=>expectClose('π÷π', 1.0,delta: 1e-9));
    test('J10 sin(π/2) + cos(π) = 0 (rad)',()
    {
      expectClose('sin(π÷2)+cos(π)',0.0,rad:true,delta:1e-9);
    });
  });
  group('K – Decimal Precision Formatting',()
  {
    test('K01 int bypasses prec=0',()=>expect(eval('4+5',prec:0),'9'));
    test('K02 int bypasses prec=5',()=>expect(eval('100÷4',prec:5),'25'));
    test('K03 1÷3 prec=2',()=>expect(eval('1÷3',prec:2),'0.33'));
    test('K04 1÷3 prec=4',()=>expect(eval('1÷3',prec:4),'0.3333'));
    test('K05 1÷3 prec=6',()=>expect(eval('1÷3',prec:6),'0.333333'));
    test('K06 1÷7 prec=3',()=>expect(eval('1÷7',prec:3),'0.143'));
    test('K07 sqrt(2) prec=5',()=>expect(eval('sqrt(2)',prec: 5),'1.41421'));
    test('K08 prec=0 rounds to int',()=>expect(eval('1÷3',prec: 0),'0'));
    test('K09 prec=10 gives 10 dp',()
    {
      final r=eval('1÷7',prec: 10);
      final dot=r.indexOf('.');
      expect(dot,greaterThan(0));
      expect(r.length-dot-1,10);
    });
    test('K10 sin(45°) is non-integer',()
    {
      expect(eval('sin(45)',prec: 5).contains('.'),isTrue);
    });
  });
  group('L – Programmer: AND / OR / XOR',()
  {
    test('L01 F AND F = F',()=>expectHex('F AND F','F'));
    test('L02 F AND 0 = 0',()=>expectHex('F AND 0','0'));
    test('L03 FF AND 0F = F',()=>expectHex('FF AND 0F','F'));
    test('L04 A AND 5 = 0',() => expectHex('A AND 5','0'));  // 1010 & 0101 = 0000
    test('L05 A OR 5 = F',()=>expectHex('A OR 5','F'));  // 1010 | 0101 = 1111
    test('L06 0 OR 0 = 0',()=>expectHex('0 OR 0','0'));
    test('L07 FF OR 0 = FF',()=>expectHex('FF OR 0','FF'));
    test('L08 A XOR 5 = F',()=>expectHex('A XOR 5','F'));
    test('L09 F XOR F = 0',()=>expectHex('F XOR F','0'));
    test('L10 FF XOR 0F = F0',()=>expectHex('FF XOR 0F','F0'));
    test('L11 XOR with self = 0',()=>expectHex('AB XOR AB','0'));
    test('L12 F AND A = A',()=>expectHex('F AND A','A'));   // 1111 & 1010 = 1010
  });
  group('M – Programmer: Arithmetic',()
  {
    test('M01 A + 5 = F',()=>expectHex('A + 5','F'));
    test('M02 10 + 10 = 20',()=>expectHex('10 + 10','20'));  // 16+16=32=0x20
    test('M03 FF + 1 = 100',()=>expectHex('FF + 1','100'));
    test('M04 F - A = 5',()=>expectHex('F - A','5'));
    test('M05 100 - 1 = FF',()=>expectHex('100 - 1','FF'));
    test('M06 3 × 4 = C',()=>expectHex('3 × 4','C'));   // 12 = 0xC
    test('M07 FF × 1 = FF',()=>expectHex('FF × 1','FF'));
    test('M08 C ÷ 4 = 3',()=>expectHex('C ÷ 4','3'));
    test('M09 FF ÷ F = 11',()=>expectHex('FF ÷ F','11')); // 255÷15=17=0x11
    test('M10 A ÷ 0 = Error',()=>expect(prog('A ÷ 0'),'Error'));
  });
  group('N – Programmer: Bit Shifts (<< / >>)',()
  {
    test('N01 1 << 4 = 10',()=>expectHex('1 << 4','10')); // 16=0x10
    test('N02 1 << 8 = 100',()=>expectHex('1 << 8','100'));
    test('N03 FF << 1 = 1FE',()=>expectHex('FF << 1','1FE'));
    test('N04 0 << 5 = 0',()=>expectHex('0 << 5','0'));
    test('N05 10 >> 4 = 1',()=>expectHex('10 >> 4','1'));  // 16>>4=1
    test('N06 100 >> 8 = 1',()=>expectHex('100 >> 8','1'));
    test('N07 FF >> 4 = F',()=>expectHex('FF >> 4','F'));  // 255>>4=15=0xF
    test('N08 0 >> 3 = 0',()=>expectHex('0 >> 3','0'));
    test('N09 round-trip A',()
    {
      final s=prog('A << 4');
      expect(prog('$s >> 4'), 'A');
    });
    test('N10 round-trip 5',()
    {
      final s=prog('5 << 8');
      expect(prog('$s >> 8'),'5');
    });
  });
  group('O – Programmer: NOT (32-bit)',()
  {
    test('O01 NOT 0 = FFFFFFFF',()=>expectHex('NOT 0','FFFFFFFF'));
    test('O02 NOT FFFFFFFF = 0',()=>expectHex('NOT FFFFFFFF','0'));
    test('O03 NOT 1 = FFFFFFFE',()=>expectHex('NOT 1','FFFFFFFE'));
    test('O04 NOT F = FFFFFFF0',()=>expectHex('NOT F','FFFFFFF0'));
    test('O05 NOT(NOT(x)) = x',()
    {
      const x='ABCD';
      expect(prog('NOT ${prog('NOT $x')}'),x);
    });
    test('O06 lowercase not',()=>expectHex('not 0','FFFFFFFF'));
  });
  group('P – Error and Edge Cases',()
  {
    test('P01 1÷0 = Error',() => expect(eval('1÷0'),'Error'));
    test('P02 0÷0 = Error',() => expect(eval('0÷0'),'Error'));
    test('P03 sqrt(-4) = Error',()=>expect(eval('sqrt(-4)'),'Error'));
    test('P04 log(0) = Error',()=>expect(eval('log(0)'),'Error'));
    test('P05 log(-5) = Error',()=>expect(eval('log(-5)'),'Error'));
    test('P06 ln(0) = Error',()=>expect(eval('ln(0)'),'Error'));
    test('P07 asin(2) = Error',()=>expect(eval('asin(2)'),'Error'));
    test('P08 acos(-2) = Error',()=>expect(eval('acos(-2)'),'Error'));
    test('P09 tan(90°) is Error or very large',()
    {
      final r=eval('tan(90)');
      final ok=r=='Error'||
          (double.tryParse(r)!=null&&double.parse(r).abs()>1e10);
      expect(ok,isTrue,reason:'tan(90°) got "$r"');
    });
    test('P10 empty expression = Error',()=>expect(eval(''),'Error'));
    test('P11 single + = Error',()=>expect(eval('+'),'Error'));
    test('P12 trailing op stripped',()=>expect(eval('5+'),'5'));
    test('P13 1e300*1e300 = Error (overflow)',()=>expect(eval('1e300×1e300'),'Error'));
    test('P14 unbalanced auto-closed',()=>expect(eval('(3+4'),'7'));
    test('P15 sqrt(-100) = Error',()=>expect(eval('sqrt(-100)'),'Error'));
    test('P16 no crash on random junk',()
    {
      expect(()=>eval('abc??##'),returnsNormally);
    });
  });
  group('Q – CalculationHistory Serialisation',()
  {
    test('Q01 round-trip toMap/fromMap',()
    {
      final ts=DateTime(2025,4,24,10,0,0);
      final orig=CalculationHistory(expression:'3+4',result: '7',timestamp: ts);
      final copy=CalculationHistory.fromMap(orig.toMap());
      expect(copy.expression,orig.expression);
      expect(copy.result,orig.result);
      expect(copy.timestamp,orig.timestamp);
    });
    test('Q02 toMap has required keys',()
    {
      final m=CalculationHistory(
          expression:'x',result:'y',timestamp:DateTime.now()).toMap();
      expect(m.containsKey('expression'),isTrue);
      expect(m.containsKey('result'),isTrue);
      expect(m.containsKey('timestamp'),isTrue);
    });
    test('Q03 expression preserved verbatim',()
    {
      const expr='log2(1024)+sqrt(9)';
      final h=CalculationHistory(expression:expr,result:'13',timestamp:DateTime.now());
      expect(CalculationHistory.fromMap(h.toMap()).expression,expr);
    });
    test('Q04 result preserved verbatim',()
    {
      const res='3.1415926536';
      final h=CalculationHistory(expression:'π',result:res,timestamp:DateTime.now());
      expect(CalculationHistory.fromMap(h.toMap()).result,res);
    });
    test('Q05 timestamp ms-precision',()
    {
      final ts=DateTime.fromMillisecondsSinceEpoch(1_700_000_000_000);
      final h=CalculationHistory(expression:'x',result:'y',timestamp:ts);
      expect(CalculationHistory.fromMap(h.toMap()).timestamp,ts);
    });
    test('Q06 unicode expression preserved',()
    {
      const expr='sin(π÷4)+cos(π÷4)';
      final h=CalculationHistory(expression:expr,result:'1.4142135624',timestamp:DateTime.now());
      expect(CalculationHistory.fromMap(h.toMap()).expression,expr);
    });
    test('Q07 empty expression allowed',()
    {
      final h=CalculationHistory(expression:'',result:'0',timestamp:DateTime.now());
      expect(CalculationHistory.fromMap(h.toMap()).expression,'');
    });
    test('Q08 negative result preserved',()
    {
      final h=CalculationHistory(expression:'0-5',result:'-5',timestamp:DateTime.now());
      expect(CalculationHistory.fromMap(h.toMap()).result,'-5');
    });
    test('Q09 Error result preserved',()
    {
      final h=CalculationHistory(expression:'1÷0',result:'Error',timestamp:DateTime.now());
      expect(CalculationHistory.fromMap(h.toMap()).result,'Error');
    });
    test('Q10 fromMap empty map does not throw',()
    {
      expect(()=>CalculationHistory.fromMap({}),returnsNormally);
    });
  });
  group('R – Lab Specification Vectors', () {
    test('R01 sin(45°)+cos(45°)=√2',()=>expectClose('sin(45)+cos(45)',math.sqrt2,delta:1e-7));
    test('R02 sin(30°)=0.5',()=>expect(eval('sin(30)'),'0.5'));
    test('R03 cos(60°)=0.5',()=>expect(eval('cos(60)'),'0.5'));
    test('R04 tan(45°)=1',()=>expectClose('tan(45)',1.0,delta:1e-9));
    test('R05 log(1000)=3',()=>expect(eval('log(1000)'),'3'));
    test('R06 ln(e)=1',()=>expectClose('ln(e)',1.0,delta:1e-9));
    test('R07 sqrt(2)≈1.41421',()=>expectClose('sqrt(2)',1.41421356,delta:1e-7));
    test('R08 5!=120',() => expect(eval('5!'),'120'));
    test('R09 FF AND 0F = F',()=>expectHex('FF AND 0F','F'));
    test('R10 1 << 4 = 10',()=>expectHex('1<<4','10'));
    test('R11 integer result has no decimal point',()
    {
      expect(eval('100÷5').contains('.'),isFalse);
    });
    test('R12 CalculationHistory full-entry round-trip',()
    {
      final e=CalculationHistory(
        expression:'sin(45)+cos(45)',
        result:'1.4142135624',
        timestamp:DateTime(2025,1,1),
      );
      final c=CalculationHistory.fromMap(e.toMap());
      expect(c.expression,e.expression);
      expect(c.result,e.result);
    });
  });
  group('S – ExpressionParser Static Helpers',()
  {
    test('S01 cbrt(8)=2.0',()=>expect(ExpressionParser.cbrt(8),2.0));
    test('S02 cbrt(-8)=-2.0',()=>expect(ExpressionParser.cbrt(-8),-2.0));
    test('S03 cbrt(0)=0.0',()=>expect(ExpressionParser.cbrt(0),0.0));
    test('S04 cbrt(1)=1.0',()=>expect(ExpressionParser.cbrt(1),1.0));
    test('S05 cbrt(1000)≈10.0',()=>expect(ExpressionParser.cbrt(1000), closeTo(10.0,1e-10)));
    test('S06 factorial(0)=1',()=>expect(ExpressionParser.factorial(0),1.0));
    test('S07 factorial(1)=1',()=>expect(ExpressionParser.factorial(1),1.0));
    test('S08 factorial(7)=5040',()=>expect(ExpressionParser.factorial(7),5040.0));
    test('S09 factorial(170) is finite',()
    {
      expect(ExpressionParser.factorial(170).isFinite,isTrue);
    });
    test('S10 factorial(171) throws',()
    {
      expect(()=>ExpressionParser.factorial(171),throwsFormatException);
    });
  });
}
