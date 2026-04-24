import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import 'basic_keypad.dart';
import 'scientific_keypad.dart';
import 'programmer_keypad.dart';
class ButtonGrid extends StatelessWidget
{
  const ButtonGrid({super.key});
  @override
  Widget build(BuildContext context)
  {
    final mode=context.select((CalculatorProvider p)=>p.mode);
    return AnimatedSwitcher(
      duration:const Duration(milliseconds:300),
      transitionBuilder:(Widget child, Animation<double> animation)
      {
        return FadeTransition(opacity:animation,child:child);
      },
      child: _getKeypadWidget(mode),
    );
  }
  Widget _getKeypadWidget(CalculatorMode mode)
  {
    switch(mode)
    {
      case CalculatorMode.basic:
        return const BasicKeypad(key: ValueKey('basic'));
      case CalculatorMode.scientific:
        return const ScientificKeypad(key: ValueKey('scientific'));
      case CalculatorMode.programmer:
        return const ProgrammerKeypad(key: ValueKey('programmer'));
    }
  }
}