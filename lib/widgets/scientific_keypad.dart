import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import 'calculator_button.dart';
class ScientificKeypad extends StatelessWidget
{
  const ScientificKeypad({super.key});
  @override
  Widget build(BuildContext context)
  {
    final is2nd  = context.select((CalculatorProvider p) => p.isSecondFunction);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final num    = isDark ? AppColors.btnNumberDark   : AppColors.btnNumberLight;
    final fn     = isDark ? AppColors.btnFunctionDark : AppColors.btnFunctionLight;
    final op     = AppColors.btnOperatorDark;
    final eq     = AppColors.lightAccent;
    final numTxt = isDark ? Colors.white : AppColors.textDark;
    final fnTxt  = isDark ? Colors.white : AppColors.textDark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _row(context, isDark, [
            _B('2nd',                   AppColors.darkAccent,  Colors.white),
            _B(is2nd ? 'asin' : 'sin',  fn, fnTxt),
            _B(is2nd ? 'acos' : 'cos',  fn, fnTxt),
            _B(is2nd ? 'atan' : 'tan',  fn, fnTxt),
            _B('ln',                    fn, fnTxt),
            _B('log',                   fn, fnTxt),
          ]),
          _row(context, isDark, [
            _B(is2nd ? 'x³' : 'x²',    fn, fnTxt),
            _B(is2nd ? '∛' : '√',      fn, fnTxt),
            _B('x^y',                   fn, fnTxt),
            _B('(',                     fn, fnTxt),
            _B(')',                     fn, fnTxt),
            _B('÷',                     op, Colors.white),
          ]),
          _row(context, isDark, [
            _B('MC', fn, AppColors.darkAccent),
            _B('7',  num, numTxt),
            _B('8',  num, numTxt),
            _B('9',  num, numTxt),
            _B('C',  fn, AppColors.lightAccent),
            _B('×',  op, Colors.white),
          ]),
          _row(context, isDark, [
            _B('MR', fn, AppColors.darkAccent),
            _B('4',  num, numTxt),
            _B('5',  num, numTxt),
            _B('6',  num, numTxt),
            _B('CE', fn, AppColors.lightAccent),
            _B('-',  op, Colors.white),
          ]),
          _row(context, isDark, [
            _B('M+', fn, AppColors.darkAccent),
            _B('1',  num, numTxt),
            _B('2',  num, numTxt),
            _B('3',  num, numTxt),
            _B('%',  fn, fnTxt),
            _B('+',  op, Colors.white),
          ]),
          _row(context, isDark, [
            _B('M-',                  fn, AppColors.darkAccent),
            _B('±',                   num, numTxt),
            _B('0',                   num, numTxt),
            _B('.',                   num, numTxt),
            _B(is2nd ? 'e' : 'π',    fn, fnTxt),
            _B('=',                   eq, Colors.white),
          ]),
        ],
      ),
    );
  }
  Widget _row(BuildContext context, bool isDark, List<_B> btns)
  {
    return Expanded(
      child: Row(
        children: btns.map((b) {
          if (b.label == 'C') {
            return CalculatorButton(
              text:      b.label,
              bgColor:   b.bg,
              textColor: b.fg,
              fontSize:  20,
              onTap:     () => _handle(context, b.label),
              onLongPress: () {
                context.read<HistoryProvider>().clearHistory();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:         Text('History cleared'),
                  duration:        Duration(seconds: 1),
                  backgroundColor: AppColors.lightAccent,
                ));
              },
            );
          }
          return CalculatorButton(
            text:      b.label,
            bgColor:   b.bg,
            textColor: b.fg,
            fontSize:  b.label.length > 3 ? 15 : 20,
            onTap:     () => _handle(context, b.label),
          );
        }).toList(),
      ),
    );
  }
  void _handle(BuildContext context, String label) {
    final calc    = context.read<CalculatorProvider>();
    final history = context.read<HistoryProvider>();
    switch (label) {
      case '2nd': calc.toggle2nd();      break;
      case 'C':   calc.clear();          break;
      case 'CE':  calc.delete();         break;
      case 'MC':  calc.memoryClear();    break;
      case 'MR':  calc.memoryRecall();   break;
      case 'M+':  calc.memoryAdd();      break;
      case 'M-':  calc.memorySubtract(); break;
      case '±':   calc.toggleSign();     break;
      case '=':
        calc.calculate();
        if (calc.result != 'Error') history.addHistory(calc.expression, calc.result);
        break;
      default:    calc.addToExpression(label);
    }
  }
}
class _B
{
  final String label;
  final Color  bg;
  final Color  fg;
  const _B(this.label, this.bg, this.fg);
}